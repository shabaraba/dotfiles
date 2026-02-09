-- Java用LSP設定（nvim-jdtls）
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    -- Java 21環境変数を設定
    vim.env.JAVA_HOME = vim.fn.expand("~/.local/share/mise/installs/java/21.0.2")

    -- jdtls設定（重複回避のためグループ作成）
    local java_group = vim.api.nvim_create_augroup('java_lsp_setup', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      group = java_group,
      callback = function()
        -- 既にjdtlsが起動済みの場合はスキップ
        for _, client in ipairs(vim.lsp.get_clients()) do
          if client.name == 'jdtls' then
            return
          end
        end

        local jdtls = require('jdtls')

        -- プロジェクトルートを取得
        local root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle'})

        -- ワークスペースディレクトリを~/.cache/jdtls配下に設定
        -- プロジェクトパスのハッシュを使って衝突を回避
        local workspace_dir = vim.fn.expand('~/.cache/jdtls/workspace_') .. vim.fn.fnamemodify(root_dir, ':t')

        -- jdtls設定（cmdは必須）
        -- Mason 2.0以降はPATHに自動追加されるため、直接実行ファイル名を使用
        local jdtls_path = 'jdtls'

        -- jdtls用のcapabilities設定
        local capabilities = require("core.lsp.handlers").capabilities()

        -- jdtls初期化オプション
        local init_options = {
          bundles = {},
          extendedClientCapabilities = jdtls.extendedClientCapabilities,
        }

        -- jdtls設定オプション
        local settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                "org.junit.jupiter.api.Assertions.*",
                "java.util.Objects.requireNonNull",
                "java.util.Objects.requireNonNullElse",
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
              },
              hashCodeEquals = {
                useJava7Objects = true,
              },
              useBlocks = true,
            },
          },
        }

        local config = {
          cmd = {
            jdtls_path,
            '-data', workspace_dir
          },
          root_dir = root_dir,
          capabilities = capabilities,
          init_options = init_options,
          settings = settings,
          handlers = {
            -- jdtlsの空レスポンスを適切に処理
            ['textDocument/definition'] = function(err, result, ctx, config)
              if result == nil or (type(result) == 'table' and vim.tbl_isempty(result)) then
                vim.notify('Definition not found', vim.log.levels.INFO)
                return
              end
              vim.lsp.handlers['textDocument/definition'](err, result, ctx, config)
            end,
            ['textDocument/references'] = function(err, result, ctx, config)
              if result == nil or (type(result) == 'table' and vim.tbl_isempty(result)) then
                vim.notify('No references found', vim.log.levels.INFO)
                return
              end
              vim.lsp.handlers['textDocument/references'](err, result, ctx, config)
            end,
          },
          on_init = function(client)
            -- jdtlsの初期化完了を通知
            vim.notify('jdtls initialized', vim.log.levels.INFO)
          end,
          on_attach = function(client, bufnr)
            require("core.lsp.handlers").on_attach(client, bufnr)

            -- Java固有のキーマッピング
            local opts = { buffer = bufnr, silent = true }
            vim.keymap.set('n', '<leader>jo', jdtls.organize_imports, opts)
            vim.keymap.set('n', '<leader>jv', jdtls.extract_variable, opts)
            vim.keymap.set('n', '<leader>jc', jdtls.extract_constant, opts)
            vim.keymap.set('v', '<leader>jm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
          end,
        }

        -- nvim-jdtlsでjdtlsを起動
        jdtls.start_or_attach(config)
      end,
    })
  end,
}