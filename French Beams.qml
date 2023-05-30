import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	menuPath: "Plugins." + qsTr("French Beams")
	version: "1.0"
	description: qsTr("Adds/Removes French Beams from the score.")
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
            title = qsTr("French Beams")
        }
    }//Component
	
	//MuseScore 4 users only
	property var useWideBeams: false
	
	onRun: {
		var full
		if (!curScore.selection && curScore.selection.elements.length == 0) {
			full = true
			cmd('select-all')
		}
		
		curScore.startCmd()
		var changeList = []
		for (var i in curScore.selection.elements) {
			if (curScore.selection.elements[i].type == Element.NOTE) {
				var chord = curScore.selection.elements[i].parent
				var duration = chord.duration.numerator / chord.duration.denominator
				if (duration < 0.125 && chord.beam) {
					changeList.push([chord, frenchBeam(numberOfBeamAlterations(duration)), (chord.stem.userLen == 0)])
				}
			}
		}
		
		for (var i in changeList) {
			changeList[i][0].stem.userLen = changeList[i][2] ? changeList[i][1] : 0
		}
		curScore.endCmd()
		
		if (full) {
			curScore.selection.clear()
		}
		smartQuit()
	}
	
	function numberOfBeamAlterations(number) {
		var i = 1
		var j = 0
		while (i > number) {
			i = i/2
			j++
		}
		return j-3
	}
	
	function frenchBeam(beamnumber) {
		return -1 * (mscoreMajorVersion >= 4  ? (useWideBeams ? 1.0 : 0.75) : (curScore.style.value("beamWidth") * (1 + curScore.style.value("beamDistance")))) * beamnumber
	}
	function smartQuit() {
		if (mscoreMajorVersion < 4) {Qt.quit()}
		else {quit()}
	}//smartQuit
}
