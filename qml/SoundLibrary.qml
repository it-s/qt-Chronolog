import QtQuick 2.3
import QtMultimedia 5.0

Item{

    function soundButtonPress(){
        buttonPress.play();
        return true;
    }

    function soundButtonClick(){
        buttonClick.play();
        return true;
    }

    function soundSnapshot(){
        snapshot.play();
        return true;
    }

    function soundAlarm(){
        alarm.play();
        return true;
    }

    SoundEffect {
            id: buttonPress
            source: "Assets/buttonPress.wav"
        }

    SoundEffect {
            id: buttonClick
            source: "Assets/buttonClick.wav"
        }

    SoundEffect {
            id: snapshot
            source: "Assets/snapshotSound.wav"
        }

    SoundEffect {
            id: alarm
            source: "Assets/alarmSound.wav"
        }

}
