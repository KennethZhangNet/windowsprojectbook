#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#
# File Info:
#     $LastChangedRevision: 55 $
#

$tracenv_dir = "C:\trac"
$trac_admin = "C:\Python25\Scripts\trac-admin.exe"

foreach ($item in get-childitem $tracenv_dir)
{
    if (test-path "$tracenv_dir\$item" -pathtype container)
    {
        .$trac_admin $tracenv_dir\$item resync   
    }
}