for file in *.whack.mp3
do
	ffmpeg -i "$file" -y -map 0:a -map_metadata -1 -aq 1 -ar 22050 -ab 32k -ac 1 "${file%.whack.mp3}.mp3"
done