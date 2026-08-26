#!/usr/bin/env bash

set -euo pipefail

WORKSPACES="${HOME}/workspaces"
PREVIEW_DIR="${HOME}/preview"
CURRENT="${PREVIEW_DIR}/current"
SERVICE="preview.service"

usage() {
    cat <<'USAGE'
Usage:
  preview-control status
  preview-control start
  preview-control stop
  preview-control restart
  preview-control current
  preview-control select <project>
  preview-control logs
USAGE
}

fail() {
    printf 'ERROR: %s\n' "$*" >&2
    exit 1
}

require_no_extra_args() {
    [ "$#" -eq 0 ] || fail "unexpected arguments"
}

select_project() {
    [ "$#" -eq 1 ] || fail "select requires exactly one project name"

    local project="$1"

    [[ "$project" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]] \
        || fail "invalid project name"

    [ -d "$WORKSPACES" ] \
        || fail "workspace directory does not exist"

    local workspaces_real
    workspaces_real="$(realpath "$WORKSPACES")"

    local candidate="${workspaces_real}/${project}"

    [ -d "$candidate" ] \
        || fail "project does not exist: $project"

    local resolved
    resolved="$(realpath "$candidate")"

    case "$resolved" in
        "${workspaces_real}/"*)
            ;;
        *)
            fail "project resolves outside authorized workspace"
            ;;
    esac

    mkdir -p "$PREVIEW_DIR"

    ln -sfn "$resolved" "$CURRENT"

    printf 'Preview project selected:\n%s\n' "$resolved"
}

[ "$#" -ge 1 ] || {
    usage
    exit 1
}

command="$1"
shift

case "$command" in
    status)
        require_no_extra_args "$@"
        systemctl --user status "$SERVICE" --no-pager
        ;;

    start)
        require_no_extra_args "$@"
        systemctl --user start "$SERVICE"
        ;;

    stop)
        require_no_extra_args "$@"
        systemctl --user stop "$SERVICE"
        ;;

    restart)
        require_no_extra_args "$@"
        systemctl --user restart "$SERVICE"
        ;;

    current)
        require_no_extra_args "$@"

        if [ -L "$CURRENT" ]; then
            readlink -f "$CURRENT"
        else
            fail "no preview project selected"
        fi
        ;;

    select)
        select_project "$@"
        ;;

    logs)
        require_no_extra_args "$@"
        journalctl --user -u "$SERVICE" -n 50 --no-pager
        ;;

    *)
        usage
        exit 1
        ;;
esac
