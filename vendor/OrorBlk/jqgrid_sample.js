<script src="javascript/jqplugins/jqgrid/grid.addons.js" type="text/javascript"></script>
<!--- This Style makes the column headers wrap --->
<style>
th.ui-th-column div{
    white-space:normal !important;
    height:auto !important;
    padding-top:2px;
padding-bottom:2px;
}
.ui-jqgrid .ui-jqgrid-sortable {cursor:default;}
</style>

<!---
This is an example of a adjacency jQuery tree grid
It also has a few extra features:
1.The pager that shows the refresh button that will refresh the grid and reset the saved state
2.Adds the filter toolbar to each column
3.Adds custom search fields "Show" and "Fully Expanded"
4.Replaces the expand and collapse functionality with one that saves the state of the grid and then calls the default
--->
<script>
 jQuery(document).ready(function()
    {
        var gdosearch = true;
     jQuery( "#tabs").tabs();
        jQuery("#list1").jqGrid({
         url:'jquerytreefile.cfc?method=gettree',
         datatype: "json",
         gridview: false,
            treeGrid: true,
treeGridModel: 'adjacency',
ExpandColumn : 'indentcode',
         colNames: ['unid','Indent Code', 'Part Number', 'Description'],
         colModel: [
         {name: 'unid',index:'unid', width:1,hidden:true,key:true},
         {name: 'indentcode', index: 'indentcode', width: 9, align: 'center', sortable: false},
         {name: 'partno', index: 'partno', width: 7, sortable: false, align: 'left' },
         {name: 'description', index: 'description', width: 13, sortable: false, align: 'left'}
         viewrecords: true,
         caption: "jQuery Tree Example",
         pager: '#pager1',
         toppager:true
});
         jQuery("#list1").jqGrid('navGrid','#pager1',{edit:false,add:false,del:false,search:false,refresh:true,beforeRefresh:function(){saveExpandedNodes([],true);}, cloneToTop:true});
         jQuery("#list1").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, groupOp:'AND', defaultSearch:'cn'});
         //This adds all the drop downs above the grid itself that do the extra searching features.
         jQuery("#mysearch").jqGrid('filterGrid','#list1',{filterModel: [
          {label:'Show:', name: 'showme', stype: 'select', defval: '#getbaselinesettings.showtype#', sopt:{value:"view1:View 1;view2:view 2;view3:View3"}},
          {label:'Fully Expanded:', name: 'expanded', stype: 'select', defval: 'false', sopt:{value:"false:No;true:Yes"}}
          ]})
        //This is used for the saving the expanding and closing of a gird
        //First we save the original function so we can call it after we do what we want
    orgExpandRow = jQuery.fn.jqGrid.expandRow;
     orgCollapseRow = jQuery.fn.jqGrid.collapseRow;
     //Now we override the expand and collapse functions to run our "updateIdsofExpandedRows" function and then call the original
jQuery.jgrid.extend({
expandRow: function (rc) {
updateIdsOfExpandedRows(rc._id_, true);
return orgExpandRow.call(this, rc);
},
collapseRow: function (rc) {
updateIdsOfExpandedRows(rc._id_, false);
return orgCollapseRow.call(this, rc);
}
});
//Define the array that holds the ids
idsOfExpandedRows = [];
//Put code for filling in the saved ids of expanded rows

    });
    function updateIdsOfExpandedRows(id, isExpanded) {
        var index = jQuery.inArray(id, idsOfExpandedRows);
        if (!isExpanded && index >= 0) {
            idsOfExpandedRows.splice(index, 1); // remove id from the list
        } else if (index < 0) {
            idsOfExpandedRows.push(id);
        }
        saveExpandedNodes(idsOfExpandedRows);
    }
    //This saves the expanded ids in the database
    function saveExpandedNodes(rowIds,reset)
    {
        if(reset == undefined)
         reset = false;
        if(reset)
        {
            jQuery("#sg_showme").val("view1");
         jQuery("#sg_expanded").val("false");
         checksearch("false");
         checksearchbarval("false");
        }	
       //First convert the array into a comma deliminted list
       var rowlist = rowIds.toString();
       jQuery.ajax({
          url:'jquerytreefile.cfc?method=saveGridSettings',
          data:{nodelist:rowlist,reset:reset},
          cache:false,
          method:'POST',
          async:true,
          success:function(data){
           result = jQuery.parseJSON(data);
            if (result.success)
            {
                //Do Nothing
            }
            else
                jQuery.gritter.add({title:'Error!',text:'Save was unsuccessful. Please contact your system administrator.'});
}
       });
    }
    //When setting the show expanded to true we want to hide the search bars.
    function checksearchbarval(value)
    {
        if(value == "true")
        {
           jQuery("input[id^='gs_']").each(function(){
jQuery(this).val('');
});
jQuery(".ui-search-toolbar").hide();
        }
        else jQuery(".ui-search-toolbar").show();
    }
</script>

<body>
<table>
<tr>
<td width="100%" style="padding-left:5px;padding-right:5px">
<div id="mysearch"></div>
<table id="list1"></table>
<div id="pager1"></div>
</td>
</tr>
</table>
</body>


