<script>
   $.getJSON('/idclist', function(res){
        var idc_str = ''
        $.each(res,functon(i,v){
             idc_str += '<tr>'
             idc_str += '<td>' + v[0] + '</td>'
             idc_str += '<td>' + v[1] + '</td>'
             idc_str += '<tr>'
        })

        $('#idc_table').html(idc_str)
   })
</script>
