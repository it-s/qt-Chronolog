import QtQuick 2.3
import QtQuick.Controls 1.2
import Qt.labs.settings 1.0
//import QtQuick.LocalStorage 2.0
//import org.labsquare 1.0

ApplicationWindow {
    id: app
    color: "#000000"
    width: 768
    height: 1280

    visible: true

//    DataBase {id: database}
//    Settings {id: settings}

    property var pages: {
                "Home":     Qt.resolvedUrl("/qml/Chronometer.qml"),
                "History":  Qt.resolvedUrl("/qml/History.qml"),
    }

    property bool firstRun: true

    //---------------------------
    //Application global functions
    //---------------------------

    function isFirstRun(){
        return firstRun;
    }

    /**
     * Go To Previous Page
     */
    function goBack(){
        if (stack.depth > 1) stack.pop()
    }

    /**
     * Go To specific
     * @param page: Page Component
     */
    function goToPage(page){
        stack.push(pages[page])
    }

    /*
    -
    - Application settings
    -
    */

    Settings {
        property alias firstRun: app.firstRun
    }

    Component.onCompleted: {
//        if(firstRun)showAppHelp("help01");
    }

    Component.onDestruction: {
        firstRun = false;
    }

    /*
    -
    - Sound library
    -
    */

    SoundLibrary{id:sound}

    /*
    -
    - Application views
    -
    */

    StackView {
        id: stack
        anchors.fill: parent
        // Implements back key navigation
        focus: true

        Keys.onReleased: {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Backspace) {
                event.accepted = currentItem.back();
            }
            if (event.key === Qt.Key_Menu || event.key === Qt.Key_Meta ) {
                event.accepted = currentItem.menu();
            }
        }

        initialItem: app.pages["Home"]

        delegate: StackViewDelegate {

            replaceTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script: {
                            Qt.inputMethod.hide(); //Hide all input methods
                            if (exitItem) exitItem.hide();
                            enterItem.show()
                            if (exitItem) exitItem.enabled = false
                        }
                    }
                    PropertyAnimation {
                        duration: enterItem.pageTransitionDuration
                        target: enterItem
                        property: "x"
                        from: enterItem.width
                        to: 0
                    }
                    ScriptAction {
                        script: {
                            if (exitItem) exitItem.hidden()
                            enterItem.shown()
                        }
                    }
                }
            }

            pushTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script: {
                            Qt.inputMethod.hide(); //Hide all input methods
                            if (exitItem) exitItem.hide();
                            enterItem.show()
                            if (exitItem) exitItem.enabled = false
                        }
                    }
                    PropertyAnimation {
                        duration: enterItem.pageTransitionDuration
                        target: enterItem
                        property: "x"
                        from: enterItem.width
                        to: 0
                    }
                    ScriptAction {
                        script: {
                            if (exitItem) exitItem.hidden()
                            enterItem.shown()
                        }
                    }
                }
            }

            popTransition: StackViewTransition {
                SequentialAnimation {
                    ScriptAction {
                        script: {
                            Qt.inputMethod.hide(); //Hide all input methods
                            exitItem.hide()
                            enterItem.show()
                            enterItem.enabled = true
                        }
                    }
                    PropertyAnimation {
                        duration: enterItem.pageTransitionDuration
                        target: exitItem
                        property: "x"
                        to: enterItem.width
                        from: 0
                    }
                    ScriptAction {
                        script: {
                            exitItem.hidden()
                            enterItem.shown()
                        }
                    }
                }
            }
        }
    }


}
