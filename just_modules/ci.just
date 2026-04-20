tailwind_exec := "tailwindcss-v4.2.2"


# Shows all commands
@default:
    just --list ci


# Minify the tailwind assets.
@tailwind-minify:
    {{ tailwind_exec }} \
    --cwd {{ justfile_directory() }} \
    -i {{ justfile_directory() }}/frontend_assets/css/input.css \
    -o {{ justfile_directory() }}/static/css/output.css \
    --minify \
    && echo "" >> {{ justfile_directory() }}/static/css/output.css
