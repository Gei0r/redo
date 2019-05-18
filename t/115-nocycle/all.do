# In this test case, the targets have the following dependency structure:
#
# all
#   - A
#   - B
#     - A
#
# That is somewhat close to a dependency cycle (B depends on A which is also
# built on the same level), but it IS NOT a cycle.
#
# So building A and B should work just fine.

rm -f A B
redo-ifchange A B

[ "$(cat B)" = "File B; A=File A" ] || exit 1
