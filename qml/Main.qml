import QtQuick
import QtQuick.Window
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import Qt.labs.platform
import "Views"
import "controls"
ApplicationWindow  {
    property string mentitle: "title"
    property bool showAddbtn: true
    property bool showRefreshBtn: false
    property bool showInfohBtn: false
    property var videoList: []
    property var currentPathPack
    property var currentVideoname
    property string currentVideoDesc: ""
    property VideoPlayer videoPlayerWindow
    property LibraryView libraryV:libraryV
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    id:win
    visible: true
    visibility: Window.Windowed

    title: qsTr("hello world1")
    MessageDialog {
        id:activiationMsg
        buttons: MessageDialog.Ok
        title: "Info"
        informativeText: "You need to activate SoneGX player in settings."
        onOkClicked: {
            swipeView.currentIndex = 2
        }
    }
    Popup {
        id:popUpAbout
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        rightMargin:20
        leftMargin: 20
        topMargin: 20
        bottomMargin: 20
        modal: true

        contentWidth: view.implicitWidth
        contentHeight: view.implicitHeight
        ScrollView{
            id: view
            anchors.fill: parent
            contentWidth: columnLayout.implicitWidth
            contentHeight: columnLayout.implicitHeight
            ColumnLayout {
                id:columnLayout
                anchors.fill: parent
                spacing: 40
                Label {
                    id: aboutVersion233
                    text: qsTr("About")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.bottomMargin: 5
                    font.bold: true
                }
                Image {
                    id: logo23
                    source: "qrc:/qml/icons/SonegX_Media_Player_LOGO-256px.png"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    antialiasing: true
                }
                Label {
                    id: aboutVersion23
                    text: qsTr("Vesion 1.0")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.bottomMargin: 15
                }
                Label {
                    id: website
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text: "Website: <a href='https://www.onlinemusikschule.info'>www.onlinemusikschule.info</a>"
                    onLinkActivated:Qt.openUrlExternally("https://www.onlinemusikschule.info")
                }
                Label {
                    id: serialValue2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text:"Top Shop Group Ltd."

                }
                Label {
                    id: serialValue3
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text:"Covent Garden"

                }
                Label {
                    id: serialValue4
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text:"London, WC2H 9JQ"

                }
                Label {
                    id: email
                    text: qsTr("Email: support@onlinemusikschule.info")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
                Label {
                    id: email4
                    text: "Phone: <a href='+43 680 2090144'>+43 680 2090144</a>"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onLinkActivated: {

                        var url = "tel:+43 680 2090144";
                        Qt.openUrlExternally(url)

                    }
                }

            }

        }

    }
    function checkActivation(){
        var deviceID=androidUtils.getAndroidID()
        var serianN=ActivateSys.getEncryptedId()
        if(ActivateSys.checkDecryption(serianN,deviceID))
            return true;
        else
            return false;
    }
    function switchToVideosView(){
        console.log("switchToVideosView()")
        swipeView.currentIndex = 1
    }
    Connections {
        target: fileCrypto
        function onPreparingVideoProgressChanged(){
            if(popupInfo.visible!=true)
                popupInfo.open()
            popupInfoText.text="Preparing video "
            popupInfoBusyIndicator.visible=true
        }

        function onEncryptionVideoProgressChanged(progress) {
            // Handle the signal here
            console.log("Encryption video progress changed:", progress)
            if(popupInfo.visible!=true)
                popupInfo.open()
            popupInfoBusyIndicator.visible=false
            popupInfoText.text="Loading video : "+progress+" %"
        }
        function onDecryptionVideoFinished(fullname) {
            popupInfo.close()
            internal.createVideoPlayerWindow()
            win.videoPlayerWindow.player.source="file://"+fullname
            console.log("videopppppppppp"+win.videoPlayerWindow.player.source)
            internal.playMode()
            win.videoPlayerWindow.visible=true
            win.videoPlayerWindow.player.play()
        }
    }
    // TODO: fix owned by unique_fd
    function playVideo(videoPath){
        if(checkActivation()){
            console.log("videoPath"+videoPath)
            //  fileCrypto.encryptVideo("pack1/project2.sngvtest3.mp4","video3.dat0","1234")
            fileCrypto.decryptVideo(videoPath,win.currentVideoname,"1234")
        }
        else
            activiationMsg.open()

        //        if(checkActivation())
        //        {
        //            console.log("videoPath"+videoPath)
        //            fileCrypto.decryptVideo(videoPath,win.currentVideoname,"1234")

        //            internal.createVideoPlayerWindow()
        //            win.videoPlayerWindow.player.source=videoPath
        //            //win.videoPlayerWindow.player.source="content://com.android.externalstorage.documents/document/primary%3ADCIM%2Fpack%2Ftest2.mp4"
        //            console.log("    win.currentPathPack"+win.currentPathPack)
        //            console.log("videopppppppppp"+win.videoPlayerWindow.player.source)
        //            internal.playMode()
        //            win.videoPlayerWindow.visible=true
        //            win.videoPlayerWindow.player.play()
        //        }
        //        else
        //            activiationMsg.open()

    }
    function testplayVideo(videoPath){
        videoPlayerWindow.player.source=videoPath
        console.log("videoPlayerWindow.player.source "+videoPlayerWindow.player.source)
        internal.playMode()
        videoPlayerWindow.visible=true
        videoPlayerWindow.player.play()
    }
    QtObject {
        id: internal
        function playMode(){
            win.header.visible=false
            win.footer.visible=false
            // win.menuBar.visible=false
            swipeView.visible=false
            win.visibility= Window.FullScreen
        }
        function basicMode(){
            win.header.visible=true
            win.footer.visible=true
            // win.menuBar.visible=true
            swipeView.visible=true
            win.visibility= Window.Windowed
        }
        function createVideoPlayerWindow() {
            var component = Qt.createComponent("qrc:/qml/Views/VideoPlayer.qml");
            if (component.status ===  Component.Ready) {
                var videoPlayerWindow = component.createObject(win);
                if (videoPlayerWindow === null) {
                    console.error("Error creating VideoPlayerWindow");
                } else {
                    // Initialize properties and settings for the new VideoPlayer
                    // ...
                    win.videoPlayerWindow=videoPlayerWindow
                }
            } else {
                console.error("Error loading VideoPlayer.qml:", component.errorString());
            }
        }
    }

    Popup {
        id: popupInfo
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        contentItem: RowLayout{
            Text {
                id:popupInfoText
                text: "Content"
                color:"white"
            }
            BusyIndicator{
                id:popupInfoBusyIndicator
                visible: false
            }
        }
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
    }
    header: ToolBar {
        Material.background: win.color
        RowLayout {
            spacing: 20
            anchors.fill: parent
            Image {
                id: logo
                source: "qrc:/qml/icons/SonegX_Media_Player_S_LOGO-64px.png"
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignTop
                antialiasing: true
                Layout.leftMargin: 20
            }
            Label {
                id: menuTitle
                font.bold: true
                text: win.mentitle
                //   elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.family: "Segoe UI"
            }
            ToolButton {
                id: addbtn
                visible: win.showAddbtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-plus.svg"
                onClicked:{
                    if (androidUtils.checkStoragePermission())
                        libraryV.libraryfileDialog.visible = true
                    else
                        return
                }
            }
            ToolButton {
                id: refreshBtn
                visible: win.showRefreshBtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-reload.svg"
                onClicked:{
                }
            }
            ToolButton {
                id: infoBtn
                visible: win.showInfohBtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-info.svg"
                onClicked:{
                    popUpAbout.open()
                }
            }
        }
    }
    footer: ToolBar {
        Material.background: "#2e2f30"
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            FooterBtn {
                id:libraryBtn
                icon.source: "qrc:/qml/icons/cil-album.svg"
                text: " Library "
                onClicked: {
                    swipeView.currentIndex = 0
                }
                function libraryView_Activeted(){
                    if(!activated){
                        win.mentitle="Library"
                        win.showAddbtn=true
                        win.showRefreshBtn=false
                        win.showInfohBtn=false
                        libraryBtn.activated=true
                        videosBtn.activated=false
                        settingsBtn.activated=false
                    }
                }
            }
            FooterBtn {
                id:videosBtn
                text: "   Videos  "
                icon.source: "qrc:/qml/icons/cil-movie.svg"
                onClicked:{
                    swipeView.currentIndex = 1
                }
                function videosView_Activeted(){
                    if(!activated){
                        console.log("videosView_Activeted()")
                        videosV.videoListModel.updateModel()
                        win.mentitle="Videos"
                        win.showAddbtn=false
                        win.showRefreshBtn=true
                        win.showInfohBtn=false
                        libraryBtn.activated=false
                        videosBtn.activated=true
                        settingsBtn.activated=false
                    }
                }
            }
            FooterBtn {
                id:settingsBtn
                text: "Settings"
                icon.source: "qrc:/qml/icons/cil-settings.svg"
                onClicked:{
                    swipeView.currentIndex = 2
                }
                function settingsView_Activeted(){
                    if(!activated){
                        win.mentitle="Settings"
                        win.showAddbtn=false
                        win.showRefreshBtn=false
                        win.showInfohBtn=true
                        libraryBtn.activated=false
                        videosBtn.activated=false
                        settingsBtn.activated=true
                    }
                }

            }
        }
    }
    //    VideoPlayer {
    //        id: videoPlayerWindow
    //        //      visible: false

    //        // Other properties and settings for the video player window
    //    }
    SwipeView {
        id: swipeView
        interactive:false
        anchors.fill: parent
        currentIndex: 0
        LibraryView {
            id:libraryV
        }
        VideosView {
            id:videosV
        }

        SettingsView {}
        Component.onCompleted: {
            win.mentitle="Library"
            libraryBtn.activated=true
        }
        onCurrentIndexChanged: {
            console.log("swipeView.currentIndex"+swipeView.currentIndex)
            // Call a function based on the new index
            switch (swipeView.currentIndex) {
            case 0:
                libraryBtn.libraryView_Activeted();
                break;
            case 1:
                videosBtn.videosView_Activeted();
                break;
            case 2:
                settingsBtn.settingsView_Activeted();
                break;
            }
        }
    }
    onClosing: function(close) {
        close.accepted = false
        if(popupInfo.visible==true|| popUpAbout.visible==true){
            popupInfo.close()
            popUpAbout.close()
        }
        else if(win.videoPlayerWindow!=null)
        {
            if(win.videoPlayerWindow.currentOrientation==0)
                androidUtils.rotateToPortrait()
            //win.videoPlayerWindow.player.stop(); // Stop the video playback if needed
            win.videoPlayerWindow.visible=false
            win.videoPlayerWindow.destroy()
            win.videoPlayerWindow = null
            console.log("Child window is closing …")
            internal.basicMode()

        }
        else if (swipeView.currentIndex!=0){

            swipeView.currentIndex = 0
        }
        else{
            close.accepted = true
            Qt.quit()
        }
    }
    Component.onCompleted: {

        androidUtils.setSecureFlag()
        internal.createVideoPlayerWindow()
        if(!checkActivation())
        {
            activiationMsg.open()
        }
    }

}
