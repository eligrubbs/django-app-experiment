# This is the global justfile. Running `just` in this or and child directory will target this file.
# If you create a `justfile` in a child directory, that one will be used instead as the main one!


mod ci "just_modules/ci.just"
mod dev "just_modules/dev.just"
mod setup "just_modules/setup.just"
