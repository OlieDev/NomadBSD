# $FreeBSD: src/share/skel/dot.login,v 1.16 2001/06/25 20:40:02 nik Exp $
#
# .login - csh login script, read by login shell, after `.cshrc' at login.
#
# see also csh(1), environ(7).
#
# vim: set tabstop=4:

if ( "`tty`" =~ "/dev/ttyv0" ) then
	/usr/libexec/nomad/nomad_setup
	pciconf -lv | grep -B3 display | grep -i nvidia >& /dev/null
	if ( $? == 0 ) then
		if (! -f /usr/local/etc/X11/xorg.conf.d/10-nvidia.conf) then
			cp /root/10-nvidia.conf /usr/local/etc/X11/xorg.conf.d/
			kldload nvidia
			kldload nvidia-modeset
		endif
	else if (-f /usr/local/etc/X11/xorg.conf.d/10-nvidia.conf) then
		rm /usr/local/etc/X11/xorg.conf.d/10-nvidia.conf
	endif
	set msg="\nStarting Xorg...\n\nThis might take a while when starting"
	set msg="$msg NomadBSD for the first time.\n\nStay tuned!\n"
	dialog --infobox "$msg" 10 40
	(service slim onestart; sleep 3; service slim onestart; sleep 3; \
	service slim onestart) >& /dev/null
endif

