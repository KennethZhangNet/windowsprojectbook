#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# rcversion-date.ps1 <Project name> <Resource file Path>

if ($args.count -eq 0)
{
	"Usage: version.ps1 <Project name> <Resourc file Path>"
	exit
}

$project = $args[0]
$rc_file_path = $args[1]
$ccnet_dir = "C:\Program Files\CruiseControl.NET\server\"

# ���� ��¥�� 2008.12.31(2008�� 12�� 31��) �������� �����Ѵ�.
$date = (get-date -uformat %Y)+"."+(get-date -format %M.%d)

# ������Ʈ state ������ XML �������� �о�´�.
[xml]$state_file = get-content -path $ccnet_dir$project.state

# state ������ Label�� ���� ��¥�� ������ �׳� ������ Ƚ��($next_version) ����
# �ٸ��� 1�� ����
if ($state_file.IntegrationResult.Label -match $date)
{
	$full_date = $date+"."

	[int]$next_version = $state_file.IntegrationResult.Label -replace $full_date, ""
	if ($state_file.IntegrationResult.Status -match "Success")
	{
		$next_version++
	}
}
else
{
	$next_version = "1"
}

# ���ҽ� ������ ������ �о�´�.
# Resource file Update.
$rc_file = get-content -path $rc_file_path
$rc_length = $rc_file.Length

# ��, ��, ��, ���� Ƚ���� �����Ͽ� ���� ���ڿ��� �����Ѵ�.
$year = get-date -uformat %Y
$month = get-date -format %M
$day = get-date -format %d
$version_string = $year+", "+$month+", "+$day+", "+$next_version

# ���ҽ� ���Ͽ��� ���� �κ��� ã�� ������ ���� ���ڿ��� ������Ʈ �Ѵ�.
for ($i = 0; $i -lt $rc_length; $i++)
{
	if ($rc_file[$i] -match " FILEVERSION ")
	{
		$rc_file[$i] = " FILEVERSION "+$version_string
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match "            VALUE `"FileVersion`", ")
	{
		$rc_file[$i] = "            VALUE `"FileVersion`", `""+$version_string+"`""
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match " PRODUCTVERSION ")
	{
		$rc_file[$i] = " PRODUCTVERSION "+$version_string
		echo "Product Version Updated"
	}

	if ($rc_file[$i] -match "            VALUE `"ProductVersion`", ")
	{
		$rc_file[$i] = "            VALUE `"ProductVersion`", `""+$version_string+"`""
		echo "Product Version Updated"
	}

	if ($rc_file[$i] -match "#define FILEVER ")
	{
		$rc_file[$i] = "#define FILEVER "+$version_string
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match "#define STRFILEVER ")
	{
		$rc_file[$i] = "#define STRFILEVER `""+$version_string+"\0"+"`""
		echo "File Version Updated"
	}

	if ($rc_file[$i] -match "#define PRODUCTVER ")
	{
		$rc_file[$i] = "#define PRODUCTVER "+$version_string
		echo "Product Version Updated"
	}

	if ($rc_file[$i] -match "#define STRPRODUCTVER ")
	{
		$rc_file[$i] = "#define STRPRODUCTVER `""+$version_string+"\0"+"`""
		echo "Product Version Updated"
	}
}

set-content -path $rc_file_path $rc_file
