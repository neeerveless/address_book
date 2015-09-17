function initialize(year, month, day) {
    //現在の年数オブジェクトを4桁で生成
    var time = new Date();
    var current_year = time.getFullYear();
    var month   = ('0' + month).slice(-2);
    var day     = ('0' +   day).slice(-2);
    //1900年まで表示
    for (var i = current_year; i >= 1900; i--) {
        $('#year').append('<option value="' + i + '">' + i + '</option>');
    }
    $('#year option[value='+year+']').attr('selected', 'selected');
    
    var zeroFilledMonth = '';
    //1～12の数字を生成
    for (var i = 1; i <= 12; i++) {
        zeroFilledMonth = ('0' + i).slice(-2);
        $('#month').append('<option value="' + zeroFilledMonth + '">' + zeroFilledMonth + '</option>');
    }
    $('#month option[value='+month+']').attr('selected', 'selected');
    
    var zeroFilledDay = '';
    //1～31の数字を生成
    for (var i = 1; i <= 31; i++) {
        zeroFilledDay = ('0' + i).slice(-2);
        $('#day').append('<option value="' + zeroFilledDay + '">' + zeroFilledDay + '</option>');
    }
    $('#day option[value='+day+']').attr('selected', 'selected');
}
