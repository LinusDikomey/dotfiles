function fix-audio --wraps='killall pulseaudio ; pulseaudio & ; disown' --wraps='killall pulseaudio && pulseaudio & && disown' --description 'alias fix-audio killall pulseaudio ; pulseaudio & ; disown'
  killall pulseaudio ; pulseaudio & ; disown $argv
        
end
