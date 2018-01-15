# NOTE: Requires jq 1.6+ (for strflocaltime)

def emph:
  if (env.SOLARIZED == "light")
  then "[1;30m" + . + "[0m"
  else "[0;37m" + . + "[0m"
  end;

def in_red:     "[0;31m" + . + "[0m";
def in_green:   "[0;32m" + . + "[0m";
def in_yellow:  "[0;33m" + . + "[0m";
def in_blue:    "[0;34m" + . + "[0m";
def in_mangeta: "[0;35m" + . + "[0m";
def in_cyan:    "[0;36m" + . + "[0m";


# Entries are stored in top level '.entries' key
.entries
# Group by common date
| group_by(.date)[]
# Remember the date for each group
# (pluck index 0 because they're all the same within a group)
| {
    date: .[0].date,
    entries: .
  }
# Pretty print
| (
    # Header for single day
    (
      "───── "
      + (.date | strptime("%F") | strflocaltime("%a, %b %d"))
      + " ──────────────────────────────────────────────────────\n"
      | emph
    ),
    # Entries within a day
    (
      .entries[]
      | (.time | strptime("%R") | strflocaltime("%I:%M %p"))
        + ": "
        + (.title | in_cyan)
        + "\n"
        # Hacky solution to ensure there aren't too many newlines
        + if (.body | length) > 1
          then "| " + (.body | rtrimstr("\n") | gsub("\n(?<c>.)"; "\n| \(.c)"))
          else ""
          end
    )
  )
