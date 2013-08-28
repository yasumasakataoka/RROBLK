# -*- coding: utf-8 -*-  
class   GanttController  <  ApplicationController
   before_filter :authenticate_user!  
   def index
	@disp_screenname_name  = "test"
project =<<-EOF
{"tasks":[{"id":"1","name":"G1（ 製品1 ）","code":"","level":0,"start":1375802883000,"duration":0,"assigs":[],"depends":""},{"id":"2","name":"G1（ 製品1 ）","code":"1 （製造場所 組立 ）","level":3,"mlevel":1,"start":1376234883000,"duration":1,"assigs":[],"depends":"3,5,6"},{"id":"3","name":"X100（ 中間品1 ）","code":"101 （製造場所　加工 ）","level":2,"mlevel":2,"start":1376062083000,"duration":2,"assigs":[],"depends":"4"},{"id":"4","name":"X800（ 素材itemZ800 ）","code":"101 （製造場所　加工 ）","level":1,"mlevel":3,"start":1376062083000,"duration":0,"assigs":[],"depends":""},{"id":"5","name":"ITEM3367（ 部品3367 ）","code":"1 （製造場所 組立 ）","level":2,"mlevel":2,"start":1376148483000,"duration":0.5,"assigs":[],"depends":""},{"id":"6","name":"ITEM3260（ 部品3260 ）","code":"101 （製造場所　加工 ）","level":2,"mlevel":2,"start":1375802883000,"duration":5,"assigs":[],"depends":""}],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }
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

