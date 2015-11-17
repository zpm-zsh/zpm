regexp=(?<=\s)-[\w\d]+(?=\s|$)
colours=yellow
=======
# number
regexp=(\s|^)\d+([.,]\d+)?(?=[\s,]|$)
colours=yellow
=======
# size
regexp=(\s|^)\d+([.,]\d+)?\s?([kKMG][bB]|[bB]|[kKMG])(?=[\s,]|$)
colours=yellow
=======
# n-n-n
regexp=(\s|^)(\d+)(\-)(\d+)(\-)(\d+)+(?=[\s,]|$)
colours=green,yellow,green,yellow,green,yellow
=======
# n:n
regexp=(\s|^)\d+(:\d+)+(?=[\s,]|$)
colours=green
=======
regexp=(?<=\d):(?=\d)
colours=yellow
=======
# -rwxrwxrwx
regexp=(-|([bcCdDlMnpPs?]))(?=[-r][-w][-xsStT][-r][-w][-xsStT][-r][-w][-xsStT])
colours=unchanged,unchanged,blue
=======
regexp=(?<=[-bcCdDlMnpPs?])(-|(r))(-|(w))(-|([xsStT]))(?=[-r][-w][-xsStT][-r][-w][-xsStT])
colours=unchanged,unchanged,green,unchanged,green,unchanged,green
=======
regexp=(?<=[-bcCdDlMnpPs?][-r][-w][-xsStT])(-|(r))(-|(w))(-|([xsStT]))(?=[-r][-w][-xsStT])
colours=unchanged,unchanged,yellow,unchanged,yellow,unchanged,yellow
=======
regexp=(?<=[-bcCdDlMnpPs?][-r][-w][-xsStT][-r][-w][-xsStT])(-|(r))(-|(w))(-|([xsStT]))
colours=unchanged,unchanged,red,unchanged,red,unchanged,red
=======
# user
regexp=(\ [a-z\-]+)\ +([a-z\-]+\ )|wheel(?=\s|$)
colours=magenta
