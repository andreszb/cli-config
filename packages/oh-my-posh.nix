# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Oh-my-posh - Cross-platform prompt theme engine
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Provides a comprehensive prompt theme with:
#   - OS and context information
#   - Git status integration
#   - Language runtime detection (Python, Java, .NET, Rust, etc.)
#   - Battery status and time display
#   - TTY-compatible fallback for basic terminals
#
# Configuration options and more information: https://ohmyposh.dev/
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
{ pkgs }:

let
  unicode = {
    u2800 = builtins.fromJSON ''"\u2800"'';
  };

  themeConfig = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      version = 3;
      console_title_template = "{{ if ne .Env.TERM \"linux\" }}{{ .Shell }} in {{ .Folder }}{{ end }}";
      blocks = [
        # Upper Left (Prompt Context)
        {
          alignment = "left";
          newline = true;
          type = "prompt";
          segments = [
            {
              background = "#0077c2";
              foreground = "#ffffff";
              leading_diamond = "╭─";
              properties = {
                linux = "";
                macos = "";
                windows = "";
              };
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }}{{ if .WSL }}WSL at {{ end }}{{.Icon}} {{ end }}";
              type = "os";
            }
            {
              background = "#ef5350";
              foreground = "#FFFB38";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }}<parentBackground></> {{ end }}";
              type = "root";
            }
            {
              background = "#FF9248";
              foreground = "#2d3436";
              powerline_symbol = "";
              properties = {
                folder_icon = "  ";
                home_icon = " ";
                style = "agnoster_full";
              };
              style = "powerline";
              template = "{{ if ne .Env.TERM \"linux\" }} {{.Path}} {{ end }}";
              type = "path";
            }
            {
              background = "#FFFB38";
              background_templates = [
                "{{ if or (.Working.Changed) (.Staging.Changed) }}#ffeb95{{ end }}"
                "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#c5e478{{ end }}"
                "{{ if gt .Ahead 0 }}#C792EA{{ end }}"
                "{{ if gt .Behind 0 }}#C792EA{{ end }}"
              ];
              foreground = "#011627";
              powerline_symbol = "";
              properties = {
                branch_icon = " ";
                fetch_status = true;
                fetch_upstream_icon = true;
              };
              style = "powerline";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}<#ef5350> \uf046 {{ .Staging.String }}</>{{ end }} {{ end }}";
              type = "git";
            }
            {
              background = "#83769c";
              foreground = "#ffffff";
              properties = {
                style = "roundrock";
                threshold = 0;
              };
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }}  {{ .FormattedMs }}${unicode.u2800}{{ end }}";
              trailing_diamond = "";
              type = "executiontime";
            }
          ];
        }
        # Upper Right (System Status)
        {
          alignment = "right";
          type = "prompt";
          segments = [
            {
              background = "#306998";
              foreground = "#FFE873";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "python";
            }
            {
              background = "#0e8ac8";
              foreground = "#ffffff";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "java";
            }
            {
              background = "#0e0e0e";
              foreground = "#0d6da8";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if .Unsupported }}{{ else }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "dotnet";
            }
            {
              background = "#f3f0ec";
              foreground = "#925837";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "rust";
            }
            {
              background = "#e1e8e9";
              foreground = "#055b9c";
              leading_diamond = " ";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "dart";
            }
            {
              background = "#ffffff";
              foreground = "#9c1006";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "ruby";
            }
            {
              background = "#ffffff";
              foreground = "#5398c2";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }}<#f5bf45></> {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}{{ end }}";
              trailing_diamond = " ";
              type = "azfunc";
            }
            {
              background = "#565656";
              foreground = "#faa029";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{.Profile}}{{if .Region}}@{{.Region}}{{end}}{{ end }}";
              trailing_diamond = " ";
              type = "aws";
            }
            {
              background = "#316ce4";
              foreground = "#ffffff";
              leading_diamond = "";
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }} {{.Context}}{{if .Namespace}} :: {{.Namespace}}{{end}}{{ end }}";
              trailing_diamond = "";
              type = "kubectl";
            }
            {
              background = "#f36943";
              background_templates = [
                "{{if eq \"Charging\" .State.String}}#b8e994{{end}}"
                "{{if eq \"Discharging\" .State.String}}#fff34e{{end}}"
                "{{if eq \"Full\" .State.String}}#33DD2D{{end}}"
              ];
              foreground = "#262626";
              invert_powerline = true;
              powerline_symbol = "";
              properties = {
                charged_icon = " ";
                charging_icon = " ";
                discharging_icon = " ";
              };
              style = "powerline";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ if not .Error }}{{ .Icon }}{{ .Percentage }}{{ end }}{{ .Error }} {{ end }}";
              type = "battery";
            }
            {
              background = "#40c4ff";
              foreground = "#ffffff";
              invert_powerline = true;
              leading_diamond = "";
              properties = {
                time_format = "15:04";
              };
              style = "diamond";
              template = "{{ if ne .Env.TERM \"linux\" }}  {{ .CurrentDate | date .Format }} {{ end }}";
              trailing_diamond = "";
              type = "time";
            }
          ];
        }
        # Lower Left (Prompt)
        {
          alignment = "left";
          newline = true;
          segments = [
            {
              foreground = "#21c7c7";
              style = "plain";
              template = "{{ if ne .Env.TERM \"linux\" }}╰─{{ end }}";
              type = "text";
            }
            {
              foreground = "#e0f8ff";
              foreground_templates = [
                "{{ if gt .Code 0 }}#ef5350{{ end }}"
              ];
              properties = {
                always_enabled = true;
              };
              style = "plain";
              template = "{{ if ne .Env.TERM \"linux\" }} {{ end }}";
              type = "status";
            }
          ];
          type = "prompt";
        }
        # TTY version - Upper Left (Simple Context)
        {
          alignment = "left";
          newline = true;
          type = "prompt";
          segments = [
            {
              style = "plain";
              template = "{{ if eq .Env.TERM \"linux\" }}[{{ end }}";
              type = "text";
            }
            {
              style = "plain";
              template = "{{ if eq .Env.TERM \"linux\" }}{{ .UserName }}@{{ .HostName }}{{ end }}";
              type = "session";
            }
            {
              style = "plain";
              template = "{{ if eq .Env.TERM \"linux\" }} {{ .Path }}{{ end }}";
              properties = {
                style = "mixed";
              };
              type = "path";
            }
            {
              style = "plain";
              template = "{{ if eq .Env.TERM \"linux\" }}]{{ end }}";
              type = "text";
            }
          ];
        }
        
        # TTY version - Right Status (Simple)
        {
          alignment = "right";
          type = "prompt";
          segments = [
            {
              style = "plain";
              template = "{{ if eq .Env.TERM \"linux\" }}[{{ .CurrentDate | date \"15:04\" }}]{{ end }}";
              type = "time";
            }
          ];
        }
        # TTY version - Lower Left (Prompt)
        {
          alignment = "left";
          newline = true;
          segments = [
            {
              style = "plain";
              template = "{{ if eq .Env.TERM \"linux\" }}> {{ end }}";
              type = "text";
            }
          ];
          type = "prompt";
        }
      ];
    };
in {
  package = pkgs.oh-my-posh;
  
  # Export the theme configuration for use in other modules
  inherit themeConfig;
  
  # Home manager configuration for oh-my-posh
  homeManagerConfig = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    useTheme = builtins.toJSON themeConfig;
  };
  
  # File configuration for theme.json
  fileConfig = {
    ".config/oh-my-posh/theme.json".text = builtins.toJSON themeConfig;
  };
}
