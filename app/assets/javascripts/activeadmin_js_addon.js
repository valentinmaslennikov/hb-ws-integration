$(document).ajaxStart(function (e) {
    $.blockUI();
}).ajaxComplete(function (e) {
    $.unblockUI();
});