function showConfirmWindow() {
    $('#black-window, #lightbox-panel').fadeIn(300);
}

function closeConfirmWindow() {
    $('#black-window, #lightbox-panel').fadeOut(300);
}

function makeConfirmWindowByColumn(obj, path) {
    $('#lightbox-panel').empty();
    var table_th = ['name', 'sex', 'age', 'address'];
    var table = $('<tabel id="confirm_table">');

    var tbody = $('<tbody>');

    var childs = obj.parentNode.parentNode.children;
    for (var i = 0; i < 4; i++) {
        var td = $('<tr>')
        .append('<th>' + table_th[i] + '</th>')
        .append('<td>' + childs[i].innerHTML + '</td>');

        tbody.append(td);
    }

    var td = $('<tr>')
    .append('<th>上記の情報を削除しますか？</th>')
    .append('<td><button class="negative_btn" onclick="closeConfirmWindow()">取消</button><button class="positive_btn" onclick="deleteExecute(\'' + path + '\')">実行</button></td>');
    tbody.append(td);

    table.append(tbody);
    $('#lightbox-panel').append(table);

    showConfirmWindow();
}

function deleteExecute(path) {
    closeConfirmWindow();
    location.href = path;
}
