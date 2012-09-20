var __snahost = "re.veritrans.co.jp";

function recoConstructor(attrs){
  var isArrayNative = function(obj){
    return(obj instanceof Array);
  };
  var utic = function(value, parent_key){
    href=window.location.href;
    href=href.replace(/^http[s]*:\/\//,"");
    if(value==1)
      href=href.replace(/index\.(html?|php|cgi)(\?.*)?$/,"$2");
    if(parent_key){
      uticv="&"+parent_key+"[utic]="+value;
    }else{
      uticv="&utic="+value;
    }
    return encodeURIComponent(href)+uticv+"&";
  };
  var enc = function(str){
    return encodeURIComponent(str);
  };
  var arrayToParam = function(array,key){
    var q = "";
    for(var i=0;i<array.length;i++){
      var subkey = key+"["+i+"]";
      if(isArrayNative(array[i])){
        q += arrayToParam(array[i],subkey);
      }else if(typeof(array[i])=="object"){
        q += objectToParam(array[i],subkey);
      }else{
        if(i=="utic"){
          q += subkey+"="+enc(array[i])+"&";
          q += key+"[id]="+utic(array[i]);
        }else{
          q += subkey+"="+enc(array[i])+"&";
        }
      }
    }
    return q;
  };
  var objectToParam = function(obj,key){
    var q = "";
    for(var k in obj){
      var subkey = key+"["+k+"]";
      if(isArrayNative(obj[k])){
        q += arrayToParam(obj[k],subkey);
      }else if(typeof(obj[k])=="object"){
        q += objectToParam(obj[k],subkey);
      }else{
        if(k=="utic"){
          q += subkey+"="+enc(obj[k])+"&";
          q += key+"[id]="+utic(obj[k]);
        }else{
          q += subkey+"="+enc(obj[k])+"&";
        }
      }
    }
    return q;
  };
  
  var idOnParamSimple = function(obj,common){
    var qs = {}; var qsk;
    if(isArrayNative(obj)){
      qs[common.k]={str:queryAssemble({},common)};
      for(var i=0;i<obj.length;i++){qs[common.k].str+="id[]="+enc(obj[i])+"&";}
    }else if(obj.utic){
      qsk=obj.k||common.k;
      if(qs[qsk]==null){qs[qsk]={str:queryAssemble(obj,common)};}
      qs[qsk].str += "id[]="+utic(obj.utic);
    }else{
      for(var k in obj){
        if(k=="items"){
          for(i=0;i<obj[k].length;i++){
            qsk=obj[k][i].k||common.k;
            if(qs[qsk]==null){qs[qsk]={str:queryAssemble(obj[k][i],common)};}
            if(obj[k][i].utic){
              qs[qsk].str += "id[]="+utic(obj[k][i].utic);
            }else{
              qs[qsk].str += "id[]="+enc(obj[k][i].id)+"&";
            }
          }
        }
      }
    }
    return qs;
  };
  var idOnParamHeavier = function(obj,common){
    var qs = {}; var qsk;
    if(isArrayNative(obj)){
      qsk=common.k;
      if(qs[qsk]==null){qs[qsk]=queryAssemble({},common);}
      for(var k=0;k<obj.length;k++){
        if(typeof(obj[k])=="string"||typeof(obj[k])=="number"){
          qs[qsk] += "items["+k+"][id]="+enc(obj[k])+"&";
        }else{
          qs[qsk] += objectToParam(obj[k],k);
        }
      }
    }else if(typeof(obj)=="object"){
      for(var k in obj){
        if(isArrayNative(obj[k])){
          var objs={};
          for(var j=0;j<obj[k].length;j++){
            qsk=obj[k][j].k||common.k;
            if(objs[qsk]==null){objs[qsk]=[];}
            objs[qsk].push(obj[k][j]);
          }
          for(var sk in objs){
            if(qs[sk]==null){qs[sk]=queryAssemble({k:sk},common);}
            delete(objs[sk].k);
            qs[sk]+=arrayToParam(objs[sk],"items");
          }
        }else if(typeof(obj[k])=="object"){
          qs[qsk] += objectToParam(obj[k],k);
        }else{
          qsk=obj.k||common.k;
          if(qs[qsk]==null){qs[qsk]=queryAssemble(obj,common);delete(obj.k)}
          if(k=='utic'){
            qs[qsk] += "items[u][id]="+utic(obj[k],"items[u]");
          }else{
            qs[qsk] += k+"="+obj[k]+"&";
          }
        }
      }
    }
    return qs;
  };
  var groupMatchedKey = function(obj,key,regex){
    var q = "";
    var params = {};
    for(var k in obj){
      if((typeof(obj[k])=="string")&&(k.search(regex) == -1)){
        q += k+"="+obj[k]+"&";
      }else{
        params[k] = obj[k];
      }
    }
    return q+objectToParam(params,key);
  };
  var basicQuery = function(q, stamp){
    q += "stamp=" + stamp + "&ref=" + enc(document.referrer) + "&";
    return q;
  };
  var fact = function(act){
    if(act=="events"){
        return "event";
    }else{
        return act;
    }
  };
  var queryAssemble = function(attrs,common){
    var q = "";
    for(var name in common){
      if(typeof(attrs[name])=="undefined"){
        q += name+"="+common[name]+"&";
      }else{
        q += name+"="+attrs[name]+"&";
      }
    }
    return q;
  };
  var reqBcon = function(bAttrs,common){
    var queries = [];
    var imgs = [];
    var i=0;
    for(var act in bAttrs){
      queries[i] = {};
      queries[i].act=act;
      switch(act){
        case("basic"):
          var stamp = new Date().getTime();
          var stampLeft;
          bqs = idOnParamSimple(bAttrs[act],common);
          for(var j in bqs){
            queries[i]={};queries[i].act=act;queries[i].qst=basicQuery(bqs[j].str,stamp);i++;
          }
          break;
        case("heavy"):
          bqs = idOnParamSimple(bAttrs[act],common);
          for(var j in bqs){queries[i]={};queries[i].act=act;queries[i].qst=bqs[j].str;i++;}
          break;
        case("heavier"):
          bqs = idOnParamHeavier(bAttrs[act],common)
          for(var j in bqs){queries[i]={};queries[i].act=act;queries[i].qst=bqs[j];i++;}
          break;
        case("user"):
          assebmled=queryAssemble(bAttrs[act],common);
          delete(bAttrs[act].k)
          queries[i].qst=assebmled+groupMatchedKey(bAttrs[act],"user",/^[eaui]\d+$/);
          i++;
          break;
        case("events"):
          assebmled=queryAssemble(bAttrs[act],common);
          delete(bAttrs[act].k)
          queries[i].qst=assebmled+groupMatchedKey(bAttrs[act],"events",/^\d+$/);
          i++;
          break;
        default:
          queries[i].qst = "";
          if(act=="query"){queries[i].qst="ref="+enc(document.referrer)+"&";}
          for(var key in bAttrs[act]){
            if(typeof(bAttrs[act][key])=="string"){
              queries[i].qst += key+"="+bAttrs[act][key]+"&";
            }else{
              queries[i].qst += objectToParam(bAttrs[act][key],key);
            }
          }
          queries[i].qst+=queryAssemble(bAttrs[act],common);
          i++;
      }
    }
    for(var i=0;i<queries.length;i++){
      var url = location.protocol+"//"+__snahost+"/api/bcon/"+fact(queries[i].act)+"?";
      document.write('<img src="'+(url+queries[i].qst).replace(/&$/,"")+'" width="1" height="1" />');
    }
  };
  var btConvInt = function(str){
    map={"basic":1,"heavy":2,"heavier":3};
    return map[str] || 1;
  };
  var reqRecVal = function(obj,key){
    if(isArrayNative(obj)){
      ret="";
      for(var i=0;i<obj.length;i++){
        if(key=="utic"){ret+="id[]="+utic(obj);}
        else if(key=="bcon_type"){ret+="bt[]="+btConvInt(obj[i])+"&";}
        else if(key=="id"){ret+=key+"[]="+enc(obj[i])+"&";}
        else{ret+=key+"[]="+obj[i]+"&";}
      }
    }else{
      if(key=="utic"){ret="id="+utic(obj);}
      else if(key=="bcon_type"){ret="bt="+btConvInt(obj)+"&";}
      else if(key=="id"){ret=key+"="+enc(obj)+"&";}
      else{ret=key+"="+obj+"&";}
    }
    return ret;
  };
  var reqRecConst = function(obj,act,common,i,target_ids,charsets){
    qs={};
    qs.qst="";
    qs.act=act;
    if(!obj.target_id){ target_ids[i] = act; }else{ target_ids[i] = obj.target_id; }
    if(!obj.charset){ charsets[i] = null; }else{ charsets[i] = obj.charset; }
    for(var key in obj){
      qs.qst += reqRecVal(obj[key],key);
    }
    qs.qst += queryAssemble(obj,common);
    return qs;
  };
  var reqRecScr = function(queries,target_ids,charsets){
    for(var i=0;i<queries.length;i++){
      var url = location.protocol+"//"+__snahost+"/api/recommend/"+queries[i].act+"?";
      var script = document.createElement('script');
      script.setAttribute('type', 'text/javascript');
      script.setAttribute('charset', charsets[i]);
      script.setAttribute('src', (url+queries[i].qst).replace(/&$/,""));
      var target = document.getElementById(target_ids[i]);
      target.appendChild(script);
    }
  };
  var reqRecommend = function(rAttrs,common){
    var queries=[];
    var target_ids=[];
    var charsets=[];
    var i=0;
    for(var act in rAttrs){
      if(isArrayNative(rAttrs[act])){
        for(var j=0;j<rAttrs[act].length;j++){queries[i]=reqRecConst(rAttrs[act][j],act,common,i,target_ids,charsets);i++;}
      }
      else{queries[i]=reqRecConst(rAttrs[act],act,common,i,target_ids,charsets);i++;}
    }
    if(window.addEventListener){
      window.addEventListener("load",function(){reqRecScr(queries,target_ids,charsets);},false);
    }else{
      window.attachEvent("onload",function(){reqRecScr(queries,target_ids,charsets);});
    }
  };
  var common_queries = {};
  for(var name in attrs){
    if(name != "bcon" && name != "recommend"){
      common_queries[name] = attrs[name];
    }
  }
  reqBcon(attrs.bcon,common_queries);
  reqRecommend(attrs.recommend,common_queries);
}
function recoConstructer(attrs){recoConstructor(attrs)}
function apiSetCtr(item_code,tmpl,link,k){
  var item_url = link.href;
  var img = new Image(0,0);
  var protocol = location.protocol;
  if (protocol == undefined) {
    protocol = "https:";
  }
  var r_num = Math.floor(Math.random() * 10000);
  img.src = protocol + "//" + __snahost + "/api/recommend/set_ctr/?id=" + item_code  +"&tmpl=" + tmpl + "&k=" + k + "&r=" + r_num;
  img.onload = function(){
    location.href = item_url;
  };
  img.onerror = function(){
    location.href = item_url;
  };
}
