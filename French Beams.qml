import QtQuick 2.0
import MuseScore 3.0

MuseScore {
	menuPath: "Plugins." + qsTr("French Beams")
	version: "2.0"
	description: qsTr("Adds/Removes French Beams from the score.")
	requiresScore: true
	
	Component.onCompleted : {
        if (mscoreMajorVersion >= 4) {
            title = qsTr("French Beams")
        }
    }//Component
	
	//USER SETTINGS=======================================
	
	property var useContext: true
	//whether the plugin should take into account surrounding notes when calculating stem length
	
	//MuseScore 4 users only
	property var useWideBeams: false
	//set this to true if the score uses wide beams instead of regular beams (Style/Beams)
	
	//====================================================
	
	onRun: {
		var full = false
		if (!curScore.selection.elements.length) {
			full = true
			cmd('select-all')
		}
		
		curScore.startCmd()
		var changeList = []
		for (var i in curScore.selection.elements) {
			if (curScore.selection.elements[i].type == Element.NOTE) {
				var chord = curScore.selection.elements[i].parent
				if (numberOfBeamAlterations(getDuration(chord)) > 0 && chord.beam) {
					changeList.push([chord, (chord.stem.userLen == 0)])
				}
			}
		}//for selection
		
		for (var i in changeList) {
			if (useContext) {
				var cursor = curScore.newCursor()
				for (var j = 0; j < curScore.nstaves; j++) {
					for (var k = 0; k < 4; k++) {
						cursor.staffIdx = j
						cursor.voice = k
						cursor.rewindToTick(changeList[i][0].parent.tick)
						
						if (cursor.element && cursor.element.is(changeList[i][0])) {
							cursor.prev()
							var prevNoteType = (cursor.element.beam && cursor.element.beam.is(changeList[i][0].beam) && cursor.element.stem) ? numberOfBeamAlterations(getDuration(cursor.element)) : 0
							cursor.next()
							var curNoteType = numberOfBeamAlterations(getDuration(changeList[i][0]))
							cursor.next()
							var nextNoteType = (cursor.element.beam && cursor.element.beam.is(changeList[i][0].beam) && cursor.element.stem) ? numberOfBeamAlterations(getDuration(cursor.element)) : 0
							changeList[i][0].stem.userLen = changeList[i][1] ? frenchBeam(Math.min(prevNoteType, curNoteType, nextNoteType)) : 0
						}
					}//for voices
				}//for staves
			} else {
				changeList[i][0].stem.userLen = changeList[i][1] ? frenchBeam(numberOfBeamAlterations(getDuration(changeList[i][0]))) : 0
			}
		}//for changeList
		
		if (full) curScore.selection.clear()
		
		curScore.endCmd()
		smartQuit()
	}//onRun
	
	function getDuration(element) {
		//returns the duration of a chord
		return element.duration.numerator / element.duration.denominator
	}//getDuration
	
	function numberOfBeamAlterations(duration) {
		//returns the number of sub-beams of a chord
		var i = 1
		var j = 0
		while (i > duration) {
			i = i/2
			j++
		}
		return j-3
	}//numberOfBeamAlterations
	
	function frenchBeam(beamnumber) {
		//calculates the exact stem length based on the number of sub-beams to account for
		return -1 * (mscoreMajorVersion >= 4  ? (useWideBeams ? 1.0 : 0.75) : (curScore.style.value("beamWidth") * (1 + curScore.style.value("beamDistance")))) * beamnumber
	}//frenchBeam
	
	function smartQuit() {
		if (mscoreMajorVersion < 4) Qt.quit()
		else quit()
	}//smartQuit
}
