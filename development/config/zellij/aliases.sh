bipane() {
  target=${1:-.}
  zellij ac new-tab --layout=bipane --cwd=$(realpath "$target")
}
