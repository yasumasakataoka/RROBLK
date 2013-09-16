# -*- coding: utf-8 -*-  
class   GanttController  <  ApplicationController
   before_filter :authenticate_user!  
   def index
	@disp_screenname_name  = "test"
project =<<-EOF
{"tasks":[{"id":"1","itm_code":"G1","itm_name":"製品1","loca_code":"","loca_name":"","pare_num":"","chil_num":"","start":1376889390000,"duration":6,"end":1377407790000,"assigs":[],"depends":"","level":"1","mlevel":"0"},{"id":"2","itm_code":"G1","itm_name":"製品1","loca_code":"1","loca_name":"製造場所 組立","pare_num":"","chil_num":"","start":1377321390000,"duration":1,"end":1377407790000,"assigs":[],"depends":"3,5,6,","level":"2","mlevel":"1"},{"id":"3","itm_code":"X100","itm_name":"中間品1","loca_code":"101","loca_name":"製造場所　加工","pare_num":"1","chil_num":"1","start":1377148590000,"duration":2,"end":1377321390000,"assigs":[],"depends":"4,","level":"2","mlevel":"2"},{"id":"4","itm_code":"X800","itm_name":"素材itemZ800","loca_code":"101","loca_name":"製造場所　加工","pare_num":"1","chil_num":"1","start":1377148590000,"duration":0,"end":1377148590000,"assigs":[],"depends":"","level":"1","mlevel":"3"},{"id":"5","itm_code":"ITEM3367","itm_name":"部品3367","loca_code":"1","loca_name":"製造場所 組立","pare_num":"1","chil_num":"1","start":1377234990000,"duration":1,"end":1377321390000,"assigs":[],"depends":"","level":"2","mlevel":"2"},{"id":"6","itm_code":"ITEM3260","itm_name":"部品3260","loca_code":"101","loca_name":"製造場所　加工","pare_num":"1","chil_num":"1","start":1376889390000,"duration":5,"end":1377321390000,"assigs":[],"depends":"","level":"2","mlevel":"2"}],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }
EOF
       @gantt_data = ""
       @gantt_data =
%Q| <script type="text/javascript">
    jQuery(document).ready(function(){
    var ge = new GanttMaster();
    ge.init(jQuery("#workSpace"));
    var workSpace = jQuery("#workSpace");
    workSpace.css({width:jQuery(window).width() - 20,height:jQuery(window).height() - 250});
    ge.loadProject(#{project});
    });
     </script>|
  end   ####テスト
end

