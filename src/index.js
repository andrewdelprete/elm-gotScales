'use strict';
const gotScales = require('got-scales').default

// SASS
require('./styles/screen.scss');

// Require index.html so it gets copied to dist
require('./index.html');

/**
 * Setup Elm Things
 */
var Elm = require('./elm/Main.elm');
window.app = Elm.Main.embed(document.getElementById('App'));

// Subscribe to setNoteType port
app.ports.setNoteType.subscribe(type => {
    app.ports.noteList.send(getNotes(type))
})

// Subscribe to setNote port
app.ports.setNote.subscribe(note => {
    app.ports.chordList.send(getChords(note))
    app.ports.scaleList.send(getScales(note))
})

setTimeout(() => {
    app.ports.noteList.send(getNotes("SHOW_NATURALS"))
    app.ports.chordList.send(getChords("C"))
    app.ports.scaleList.send(getScales("C"))
}, 0)

/**
 * Retrieves the notes (naturals or sharps and flats) from the `Got Scales?` library based upon our filter
 * @param  { string } filter - The action note type
 * @return { array } - An array of notes
 */
function getNotes(filter) {
    if (filter == 'SHOW_SHARPS_AND_FLATS') {
        return gotScales.notesArray.filter(note => _.contains(note, 'b' || '#'))
    } else {
        return gotScales.notesArray.filter(note => !_.contains(note, 'b' || '#'))
    }
}

/**
 * Get an array on scales from the `Got Scales?`library based upon base note
 * @param  { string } filter - The action note type
 * @return { array } - An array of notes
 */
function getScales(note) {
    return gotScales.scaleFormulas.map(scale => {
        return {
            name: scale.name,
            notes: gotScales.note(note).scale(scale.name).getNotes()
        }
    });
}

/**
 * Get an array on chords from the `Got Scales?`library based upon base note
 * @param  { string } filter - The action note type
 * @return { array } - An array of notes
 */
function getChords(note) {
    return gotScales.chordFormulas.map(chord => {
        return {
            name: chord.name,
            notes: gotScales.note(note).scale(chord.pattern, true).getNotes()
        }
    });
}
