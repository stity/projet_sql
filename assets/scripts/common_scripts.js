var append_button = function (parent, color, id, text) {
    parent.append('<div id="' + id + '" class="modal-button modal-ok ' + color + '">' + text + '</div>');
};

var parse_field_texts = function (obj) {
    str = '';
    $.each(obj, function(key, val){
        str += '<div style="display:table-row"><p class="form-label">' + val.label + ' : </p><input type="text" name="' + key + '" value="' +  val.default +'"/></div>';
    });
    return str;
};

var parse_field_binary = function(obj) {
    str = '';
    $.each(obj, function(key, val){
        str += '<div style="display:table-row"><p class="form-label">' + val.label + ' : </p>' +
            '<div style="display:inline; margin-right:20px"><input class="radio-btn" type="radio" name="' + key + '" value="oui" ' + (val.checked == 'oui' ? 'checked' : '') + '>Oui</div>' +
            '<div style="display:inline"><input class="radio-btn" type="radio" name="' + key + '" value="non" ' + (val.checked == 'non' ? 'checked' : '') +'>Non</div>' +
        '</div>'
    });
    return str;
};

var parse_multiple_choices = function(obj) {
    str = '';
    $.each(obj, function(key, val){
        str += '<div style="display:table-row"><p class="form-label">' + val.label + ' : </p>';
        str += '<select style="margin-top:2px" name="' + key+ '">';
        $.each(val.choices, function(key_, val_){
            str += '<option ' + (val_.id == val.default ? 'selected="selected"' : '') + 'value="' + val_.id + '">' + val_.nom + '</option>';
        })
        str += '</select></div>';
    })
    return str;
}

var parse_field_date = function(obj) {
    str = '';
    $.each(obj, function(key, val){
        str += '<div style="display:table-row"><p class="form-label">' + val.label + ' : </p>' + '<input id="date_picker_' + key + '" type="datetime" name="' + key + '"></div>';
    });
    return str;
}

var parse_field_checkbox = function(obj) {
    str = '';
    $.each(obj, function(key, val){
        str += '<div style="display:table-row;">' + '<input name="zone_geo_' + val.id + '" style="width:20pt; vertical-align:baseline;" type="checkbox" ' + (val.checked ? 'checked ' : '') + 'value=' + val.id + '><p class="form-label">' + val.nom + '</p></div>';
    });
    return str;
}

var enable_datepickers = function(obj) {
    // Ceci ne fonctionne pas...
    $.each(obj, function(key, val){
        //$( "#date_picker_" +key ).datepicker({ dateFormat: 'yy-mm-dd' });
    })
}

var create_modal = function (id, title, fields_text, fields_binary, cancel_behaviour, multiple_choices, field_date, field_checkbox) {
    $('#modal_' + id).remove();
    $(document.body).append(
        '<div class="modal" id="modal_' + id + '">' +
            '<div class="modal-content">' +
            '<h1 class="modal-title">' + title + '</h1>' +
            '<hr class="modal-row"/>' +
            '<form action="" method="post" id="form_' + id + '">' +
                parse_field_texts(fields_text) +
                parse_field_binary(fields_binary) +
                parse_multiple_choices(multiple_choices) +
                parse_field_date(field_date) +
                parse_field_checkbox(field_checkbox) +
                '<input type="hidden" name="form_name" value="form_' + id + '"/>' +
                '<hr class="modal-row"/>' +
                '<div class="modal-button">' +
                    '<div id="ok_' + id + '" class="modal-button modal-ok">OK</div>' +
                    '<div id="cancel_' + id + '" class="modal-button modal-cancel">Annuler</div>' +
                '</div>' +
            '</form>' +
            '</div>' +
        '</div>'
    );

    enable_datepickers(field_date);

    $('#' + id).on('click', function(){
        $('#modal_' + id).toggle();
    });

    $('#ok_' + id ).on('click', function(){
        $('#form_' + id).submit();
    });

    if (cancel_behaviour == 'reset'){
        $('#cancel_' + id).on('click', function(){
            $('#form_' + id + ' input').val('');
            $('#modal_' + id).toggle();
        });
    } else if(cancel_behaviour == 'remove'){
        $('#cancel_' + id).on('click', function(){
            $('#modal_' + id).remove();
        });
    }
};

var create_more_details_modal = function (content, title, id) {
    $('#modal_details_' + id).remove();
    $(document.body).append(
        '<div class="modal" id="modal_details_' + id + '">' +
            '<div class="modal-content">' +
                '<h1 class="modal-title">' + title + '</h1>' +
                '<hr class="modal-row"/>' +
                content +
                '<div class="modal-button">' +
                    '<div id="ok_details_' + id + '" class="modal-button modal-ok">OK</div>' +
                '</div>' +
            '</div>' +
        '</div>'
    );

    $('#modal_details_'+id).toggle();

    $('#ok_details_'+id).on('click', function(){
        $('#modal_details_'+id).toggle();
    });
};
