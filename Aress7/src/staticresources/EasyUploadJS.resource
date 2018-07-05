   /*
    @Author - Joey Q. Chan (joeyqchan@gmail.com)
    Credits to TehNrd for the inspiration in building this app
    http://www.tehnrd.com/multi-file-uploader-for-salesforce-oh-ya-and-progress-bars-too/
*/
var j$ = jQuery.noConflict();
j$(document).ready(function () {
    j$("#uploadButton").click(function () {
        prepareFileUploads()
    });
    j$("#clear").on('click', function () {
        j$(".upload").remove()
    })
});
var byteChunkArray;
var files;
var currentFile;
var $upload;
var VIEW_URL = '/servlet/servlet.FileDownload?file=';

function prepareFileUploads() {
    files = document.getElementById('filesInput').files;
    if (files.length == 0) {
        alert('Please select a file first by clicking the "Choose Files" button.');
        return
    }
    j$(".uploadBox input").attr("disabled", "disabled");
    j$(".uploadBox button").attr({
        disabled: "disabled",
        class: "btnDisabled"
    });
    var uploadMarkup = '';
    for (i = 0; i < files.length; i++) {
        if (files[i].size < 1000000) {
            var displaySize = Math.floor(files[i].size / 1000) + 'K'
        } else {
            var displaySize = Math.round((files[i].size / 1000000) * 10) / 10 + 'MB'
        }
        if (files[i].size < 5200000) {
            uploadMarkup += '<div class="upload" data-status="pending" data-index="' + i + '">';
            uploadMarkup += '<div class="fileName"><span class="name">' + files[i].name + '</span> - (' + displaySize + ')</div>';
            uploadMarkup += '<div class="percentComplete">Pending</div>'
            uploadMarkup += '<div class="clear"/>';
            uploadMarkup += '</div>'
        } else {
            uploadMarkup += '<div class="upload" data-status="complete" data-index="' + i + '">';
            uploadMarkup += '<div class="fileName"><span class="name">' + files[i].name + '</span> - (' + displaySize + ')</div>';
            uploadMarkup += '<div class="percentComplete">ERROR: File size too big</div>'
            uploadMarkup += '<div class="clear"/>';
            uploadMarkup += '</div>'
        }
    }
    j$('.uploadBox').append(uploadMarkup);
    checkForUploads()
}
function checkForUploads() {
    $upload = j$(".upload:first[data-status='pending']");
    if ($upload.length != 0) {
        currentFile = files[$upload.attr('data-index')];
        byteChunkArray = new Array();
        byteChunkArray[0] = '0-' + (currentFile.size - 1);
        processData('')
    } else {
        j$(".uploadBox input").removeAttr("disabled");
        j$(".uploadBox button").removeAttr("disabled").attr("class", "btn");
        j$("#filesInput").replaceWith('<input type="file" name="file" multiple="true" id="filesInput">')
    }
}
function processData(attachmentId) {
    $upload.find(".percentComplete").text('Uploading... (This may take a while depending on the file size)');
    if (byteChunkArray.length > 0) {
        // var blobChunk = currentFile.slice(0, currentFile.size)
        var reader = new FileReader();
        reader.readAsDataURL(currentFile);
        reader.onloadend = function (evt) {
            if (evt.target.readyState == FileReader.DONE) {
                // var base64value = window.btoa(evt.target.result);
                console.log(evt.target);
                var att = new sforce.SObject("Attachment");
                att.ParentId = parentId;
                att.Name = currentFile.name;
                att.Body = evt.target.result.split(',')[1];
                sforce.connection.create([att], {
                    onSuccess: function (result) {
                        if (result[0].getBoolean("success")) {
                            byteChunkArray.shift();
                            attachmentId = result[0].id;
                            processData(attachmentId);
                            console.log("New attachment created with id " + result[0].id)
                        } else {
                            console.log("Failed to create attachment " + result[0]);
                            $upload.attr('data-status', 'complete');
                            $upload.addClass('uploadError');
                            $upload.attr('title', event.message);
                            checkForUploads()
                        }
                    },
                    onFailure: function (error) {
                        console.log("oops something went wrong " + error);
                        console.log("failed to create att " + result[0]);
                        $upload.attr('data-status', 'complete');
                        $upload.addClass('uploadError');
                        $upload.attr('title', event.message);
                        checkForUploads()
                    }
                })
            } else {
                alert('Error in reading the file')
            }
        }
    } else {
        $upload.find(".percentComplete").text('Upload complete');
        $upload.attr('data-status', 'complete');
        $upload.find(".name").html(currentFile.name + ' - <a href="' + VIEW_URL + attachmentId + '" target="_blank">View</a>');
        checkForUploads()
    }
}