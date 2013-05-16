%w(
  xvfb
  fluxbox
  x11vnc
  dbus

  python-gobject-2
  curl
  git

  libasound2
  libqt4-dbus
  libqt4-network
  libqtcore4
  libqtgui4
  libxss1
  libpython2.7
  libqt4-xml
  libaudio2
  libmng1
  fontconfig
  liblcms1

  lib32stdc++6
  lib32asound2
  ia32-libs
  libc6-i386
  lib32gcc1
).each do |skype4py_dependency|
  package skype4py_dependency do
    action :install
  end
end
