#
# Copyright 2007
#     PYRASIS.COM,.  All rights reserved.
#
# http://www.pyrasis.com
#
# Author:
#     Lee Jae-Hong (pyrasis)
#

# release.ps1 <Release Path> <Source Path>

$release = $args[0]
$source = $args[1]
$logfile = "C:\Windows\temp\log.xml"

# $source ���丮�� ������ Ŀ�� �α׸� $logfile�� ����
svn log $source -r COMMITTED > $logfile
$log = get-content -path $logfile

# trac���� �α� �޽����� ���������� �����ֱ� ���� �ٹٲ��� �� �� [[BR]] �߰�.
# �� ---�� ���
for ($i = 1; $i -lt 128; $i++)
{
	if ($log[$i] -match "---") {break}

	$message += "[[BR]]" + $log[$i]
}

# �α� ���뿡�� " �� ' ����
# �α� ���뿡 " �� '�� ������ Ŀ�ǵ� ���ο����� ��η� �ν��Ͽ� Ŀ���� ���������� ���� ����.
$message = $message.replace("`"", "")
$message = $message.replace("`'", "")

# ����� ������ �߰��� �� Ŀ��, ����ڸ�� ��ȣ�� �����ؾ� ��.
svn add $release --force
svn ci $release -m "$message" --username sampleuser --password abcd1234 --no-auth-cache

# �ӽ� ������ �α� ���� ����.
del $logfile

# $source ���丮�� ������� �ǵ���.
C:\tools\revert.ps1 $source
