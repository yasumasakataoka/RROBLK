class   GanttController  <  ApplicationController
   before_filter :authenticate_user!  
   def index
	@disp_screenname_name  = "test"
project =<<-EOF
{"tasks":[
    {"id":"a","name":"Gantt editor","code":"zzzzzzzzzzzzz","level":0,"status":"STATUS_ACTIVE","start":1346623200000,"duration":10,"end":1348524999999,"startIsMilestone":true,"endIsMilestone":false,"assigs":[]},
    {"id":"b","name":"coding","code":"","level":1,"status":"STATUS_ACTIVE","start":1346623200000,"duration":10,"end":1347659999999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"description":"aaaaaaaaaaaa","progress":100},
    {"id":-3,"name":"gant part","code":"","description":"Approval of testing","level":2,"status":"STATUS_ACTIVE","start":1346623200000,"duration":2,"end":1346795999999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":""},
    {"id":-4,"name":"editor part","code":"","level":2,"status":"STATUS_SUSPENDED","start":1346796000000,"duration":4,"end":1347314399999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"3"},
    {"id":-5,"name":"testing","code":"","level":1,"status":"STATUS_SUSPENDED","start":1347832800000,"duration":6,"end":1348523999999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"2:5","description":"","progress":0},
    {"id":-6,"name":"test on safari","code":"","level":2,"status":"STATUS_SUSPENDED","start":1347832800000,"duration":2,"end":1348005599999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":""},
    {"id":-7,"name":"test on ie","code":"","level":2,"status":"STATUS_SUSPENDED","start":1348005600000,"duration":3,"end":1348264799999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"6"},
    {"id":-8,"name":"test on chrome","code":"","level":2,"status":"STATUS_SUSPENDED","start":1348005600000,"duration":2,"end":1348178399999,"startIsMilestone":false,"endIsMilestone":false,"assigs":[],"depends":"6"}
    ],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }
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

