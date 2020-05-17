#!/bin/bash
# arglist.sh
# Invoke this script with several arguments, such as
#
#     arglist.sh apple banana orange "delicious fruit"

E_BADARGS=85

if [ "$#" = 0 ]
then
  echo "No args provided."
  echo "Usage: arglist.sh arg ..."
  exit $E_BADARGS
fi

echo

index=1          # Initialize count.

echo "Listing args with \"\$*\":"
for arg in "$*"  # Doesn't work properly if "$*" isn't quoted.
do
  echo "Arg #$index = $arg"
  let "index+=1"
done             # $* sees all arguments as single word.
echo "Entire arg list seen as single word."

echo

index=1          # Reset count.
                 # What happens if you forget to do this?

echo "Listing args with \"\$@\":"
for arg in "$@"
do
  echo "Arg #$index = $arg"
  let "index+=1"
done             # $@ sees arguments as separate words.
echo "Arg list seen as separate words."

echo

index=1          # Reset count.

echo "For loop without arguments:"
for arg
do
  echo "Arg #$index = $arg"
  let "index+=1"
done             # $@ sees arguments as separate words.
echo "Arg list seen as separate words."

echo

index=1          # Reset count.

echo "Listing args with \$* (unquoted):"
for arg in $*
do
  echo "Arg #$index = $arg"
  let "index+=1"
done             # Unquoted $* sees arguments as separate words.
echo "Arg list seen as separate words."

echo

index=1          # Reset count.

echo "Listing args with \$@ (unquoted):"
for arg in $@
do
  echo "Arg #$index = $arg"
  let "index+=1"
done             # $@ sees arguments as separate words.
echo "Arg list seen as separate words, even quoted words in input."

echo

index=1          # Reset count.

echo "Listing all args without program name"
for arg in ${@:2}
do
  echo "Arg #$index = $arg"
  let "index+=1"
done


exit 0
