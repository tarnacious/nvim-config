{ pkgs }:
{
  deps = with pkgs; [
    nodePackages.typescript-language-server
  ];
}
