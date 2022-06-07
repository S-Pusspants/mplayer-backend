#!/bin/zsh
#
AUDIGY=$(pactl list sinks | command grep -e 'analog-surround-51' | command grep -e 'Name: alsa_output.pci' | cut -f2 -d' ' )

init(){
    pactl set-sink-volume ${AUDIGY} 10%
    killall -9 parec
    killall -9 mplayer
    pactl unload-module module-null-sink
#    systemctl --user restart pipewire
    pactl set-sink-volume ${AUDIGY} 10%
}

twopointone() {
pactl load-module module-null-sink\
      sink_name=mplayer_2-1\
      channels=2\
      rate=44100\
      format=s32le\
      sink_properties=device.description=mplayer-backend_2.1
    
parec -d mplayer_2-1.monitor\
      --no-remix\
      --rate=44100\
      --channels=2\
      --latency-msec=1\
      --volume 65534 | mplayer\
			   -rawaudio samplesize=2:channels=2:rate=44100:bitrate=44100\
			   -af channels=6,sub=80:5\
			   -volume 50\
			   -nocache\
			   -demuxer rawaudio\
			   -really-quiet - 2<&0 &
pactl set-sink-volume mplayer_2-1 140%
}

threepointone(){
pactl load-module module-null-sink\
      sink_name=mplayer_3-1\
      channels=2\
      rate=44100\
      format=s32le\
      sink_properties=device.description=mplayer-backend_3.1

parec -d mplayer_3-1.monitor\
      --no-remix\
      --rate=44100\
      --channels=2\
      --latency-msec=10\
      --volume 65534 | mplayer\
			   -rawaudio samplesize=2:channels=2:rate=44100:bitrate=44100\
			   -af channels=6,sub=80:5,center=4\
			   -volume 50\
			   -nocache\
			   -demuxer rawaudio\
			   -really-quiet - 2<&0 &
pactl set-sink-volume mplayer_3-1 100%
}

fivepointone(){
    pactl load-module module-null-sink\
	  sink_name=mplayer_5-1\
	  channels=2\
	  format=s32le\
	  rate=44100\
	  sink_properties=device.description=mplayer-backend_5.1

    parec -d mplayer_5-1.monitor\
	  --no-remix\
	  --rate=44100\
	  --channels=2\
	  --latency-msec=10\
	  --volume 65534 | mplayer\
			       -rawaudio samplesize=2:channels=2:rate=44100:bitrate=44100\
			       -af surround=15,channels=6,sub=80:5,center=4\
			       -volume 50\
			       -nocache\
			       -demuxer rawaudio\
			       -really-quiet - 2<&0 &
        pactl set-sink-volume mplayer_5-1 100%
}

fourpointone(){
    pactl load-module module-null-sink\
      sink_name=mplayer_4-1\
      channels=2\
      format=s32le\
      rate=44100\
      sink_properties=device.description=mplayer-backend_4.1
    parec -d mplayer_4-1.monitor\
	  --no-remix\
	  --rate=44100\
	  --channels=2\
	  --latency-msec=10\
	  --volume 65534 | mplayer\
			       -rawaudio samplesize=2:channels=2:rate=44100:bitrate=44100\
			       -af surround=15,channels=6,sub=80:5\
			       -volume 50\
			       -nocache\
			       -demuxer rawaudio\
			       -really-quiet - 2<&0 &
    pactl set-sink-volume mplayer_4-1 100%
}


init
twopointone
#threepointone
#fourpointone
fivepointone

pactl set-sink-volume alsa_output.pci-0000_06_00.0.analog-surround-51 20%
pactl set-sink-volume mplayer_2-1 140%
#pactl set-sink-volume mplayer_3-1 140%
#pactl set-sink-volume mplayer_4-1 140%
pactl set-sink-volume mplayer_5-1 140%
