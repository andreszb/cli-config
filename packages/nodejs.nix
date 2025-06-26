{
  pkgs,
}: let
  # Node.js with essential packages for development
  nodePackages = with pkgs.nodePackages; [
    # Core development tools
    npm
    yarn
    pnpm
    
    # Code quality and formatting
    eslint
    prettier
    
    # TypeScript
    typescript
    typescript-language-server
    
    # Build tools and bundlers
    webpack
    webpack-cli
    
    # Development utilities
    nodemon
    concurrently
    
    # Package management
    npm-check-updates
    
    # Development servers
    serve
    http-server
  ];
in {
  package = [
    pkgs.nodejs_20  # Node.js LTS
    pkgs.corepack   # Package manager manager (yarn, pnpm)
  ] ++ nodePackages;

  homeManagerConfig = {
    # Node.js-specific home manager config can be added here if needed
  };
}