# ac3-conversion-scripts
My tablet couldn't play AC3 and m4v repository had about 20% AC3 instead of AAC.  This script converted them.

This script uses ffmpeg and the default aac codec to convert any M4V file with an AC3 audio encoding to an AAC coding with 160k bit rate.  It uses passthrough for video using -vcodec copy.
