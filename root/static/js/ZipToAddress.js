const ZIP_CODE_FORMAT = /\d{3}-\d{4}/;
function search_addr() {
    if (is_valid_zip_code($('#zip').val())) {
        AjaxZip3.zip2addr('zip','','address','address');
    }
}

function is_valid_zip_code(zip_code) {
    if (zip_code.match(ZIP_CODE_FORMAT)) {
        return true;
    }

    return false;
}
