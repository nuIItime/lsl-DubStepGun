list angle_animation=["[-1]","[-2]","[-3]","[-4]","[-5]","[1]","[2]","[3]","[4]","[5]"];

string notecardName = "!uuids";
string note_name;
string anim0;

integer aim_or_down_animation = TRUE;
integer ichannel = 07899;
integer cur_page = 1;
integer chanhandlr;
integer num;

integer slider3;
integer slider4;
integer intLine1;
integer particle2;

float event_time =.01;

key keyConfigQueryhandle;
key keyConfigUUID;
key owner;

integer getLinkNum(string primName)
{
integer primCount = llGetNumberOfPrims();
integer i;
for (i=0; i<primCount+1;i++){  
if (llGetLinkName(i)==primName) return i;
}
return FALSE;
}
startup()
{
owner = llGetOwner(); 
slider3 = getLinkNum("slider3");
slider4 = getLinkNum("slider4"); 
particle2 = getLinkNum("particle2");
llLinksetDataDeleteFound("temp-","");
llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"1"]);
llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"0"]);
llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);
}
angle_anim(string animation) 
{
  if(animation != anim0)
  {
    integer x;
    integer Lengthx = llGetListLength(angle_animation);
    for ( ; x < Lengthx; x += 1)
    {
      if(llGetOwner() == owner)
      {
      if(animation == llList2String(angle_animation,x)){ anim0 = animation; llStartAnimation(animation); }else{ llStopAnimation(llList2String(angle_animation, x)); }
      }
    }
  }
}
aim_angle(integer A)
{
if(A==0){angle_anim("NULL");}
if(A==1){angle_anim("[1]");}
if(A==2){angle_anim("[2]");}
if(A==3){angle_anim("[3]");}
if(A==4){angle_anim("[4]");}
if(A==5){angle_anim("[5]");}
if(A==-1){angle_anim("[-1]");}
if(A==-2){angle_anim("[-2]");}
if(A==-3){angle_anim("[-3]");}
if(A==-4){angle_anim("[-4]");}
if(A==-5){angle_anim("[-5]");}
}
integer readnote(string notename,integer switch)
{
 if(switch == 0)
 { 
    if(llGetInventoryType(notename) == INVENTORY_NONE)
    {
    llMessageLinked(LINK_THIS,0,"upload_note|idle_music="+notename,"");    
    llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"1"]);
    llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"2"]);
    return 2;
    }
    if(llGetInventoryType(notename) == INVENTORY_SOUND)
    {
    llMessageLinked(LINK_THIS,0,"upload_note|idle_music=" +(string)llGetInventoryKey(notename),"");
    llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"1"]);
    llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"0"]);
    return 2;
    }
    if(llGetInventoryType(notename) == INVENTORY_NOTECARD)
    {
    note_name = notename; intLine1 = 0;
    keyConfigQueryhandle = llGetNotecardLine(notename, intLine1);
    keyConfigUUID = llGetInventoryKey(notename);
    llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"0"]);
    llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"1"]);
    return 1;
    }
 }
 if(switch == 1)
 { 
      list x = llParseString2List(notename, ["|"], []);
      if(llGetInventoryType(notename) == INVENTORY_NONE)
      {
         llSetLinkPrimitiveParamsFast(particle2,[PRIM_DESC,llList2String(x,0)]); 
         llMessageLinked(LINK_THIS,5,notename,""); 
         if(llList2String(x,2) == "u")
         {
         llMessageLinked(LINK_THIS,0,"upload_note|idle_music="+llList2String(x,1),"");
         llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"1"]);
         llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"2"]);
         return 2;
         }
         if(llList2String(x,1) == "s")
         {
         llMessageLinked(LINK_THIS,0,"upload_note|idle_music="+(string)llGetInventoryKey(llList2String(x,0)),"");
         llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"1"]);
         llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"0"]);
         return 2;
         }
         if(llList2String(x,1) == "n")
         {
         note_name = llList2String(x,0); intLine1 = 0;
         keyConfigQueryhandle = llGetNotecardLine(llList2String(x,0), intLine1);
         keyConfigUUID = llGetInventoryKey(llList2String(x,0));
         llSetLinkPrimitiveParamsFast(slider4,[PRIM_DESC,"0"]);
         llSetLinkPrimitiveParamsFast(slider3,[PRIM_DESC,"1"]);
         return 1;
         }
      }
   }return 0;
}
list order_buttons(list buttons)
{
return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) +
llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}
list numerizelist(list tlist, integer start, string apnd)
{
list newlist; integer lsize = llGetListLength(tlist); integer i;
for(; i < lsize; i++)
{
newlist += [(string)(start + i) + apnd + llList2String(tlist, i)];
}return newlist;}
dialog_songmenu(integer page)
{
integer slist_size = num;
integer pag_amt = llCeil((float)slist_size / 9.0);
if(page > pag_amt) page = 1;
else if(page < 1) page = pag_amt;
cur_page = page; integer songsonpage;
if(page == pag_amt)
songsonpage = slist_size % 9;
if(songsonpage == 0)
songsonpage = 9; integer fspnum = (page*9)-9; list dbuf; integer i;
for(; i < songsonpage; ++i)
{
dbuf += ["Play #" + (string)(fspnum+i)];
}
list snlist = numerizelist(make_list(fspnum,i), fspnum, ". ");
llDialog(llGetOwner(),"result "+(string)num+"\n\n"+
llDumpList2String(snlist, "\n"),order_buttons(dbuf + ["<<<", "[ main ]", ">>>"]),ichannel);
}
list make_list(integer a,integer b) 
{
  list inventory; integer i;
  for(i = 0; i < b; ++i)
  {
  list items = llParseString2List(llLinksetDataRead("temp-"+(string)(a+i)),["|"],[]);
  string name = llDeleteSubString(llList2String(items,0),40,1000);
  if(name == notecardName){inventory += "null";}else{inventory += llDeleteSubString(name,40,1000);}
  }return inventory;
}
dialog0()
{
if (!num){llMessageLinked(LINK_THIS, 0,"mainmenu_request",""); llOwnerSay("Could not find anything"); return;}
ichannel = llFloor(llFrand(1000000) - 100000); llListenRemove(chanhandlr); chanhandlr = llListen(ichannel, "", NULL_KEY, ""); dialog_songmenu(cur_page);
}
match(string a,string b,string c,integer d){if(~llSubStringIndex(llToLower(b),llToLower(a))){llLinksetDataWrite("temp-"+(string)num,b+"|"+c+"|"+(string)d); num = num + 1;}}
search_engine(string search)
{
num=0;
llLinksetDataDeleteFound("temp-","");
integer x;
integer y0 = (integer)llLinksetDataRead("uuid");
integer y1 = llGetInventoryNumber(INVENTORY_SOUND);
integer y2 = llGetInventoryNumber(INVENTORY_NOTECARD);
for( ; x < y0; x += 1){match(search,llLinksetDataRead("m-"+(string)x),"u",x);} x=0;
for( ; x < y1; x += 1){match(search,llGetInventoryName(INVENTORY_SOUND,x),"s",x);} x=0;
for( ; x < y2; x += 1){match(search,llGetInventoryName(INVENTORY_NOTECARD,x),"n",x);} x=0;
}
default 
{ 
    changed(integer change)
    {
    if(change & CHANGED_INVENTORY){llResetScript();}
    }
    on_rez(integer start_param) 
    {
    llResetScript();
    }
    state_entry() 
    {
    startup();
    }
    run_time_permissions(integer perm)
    {
    if(PERMISSION_TAKE_CONTROLS & perm){llTakeControls( CONTROL_BACK|CONTROL_FWD, TRUE, TRUE );}
    }
    listen(integer chan, string sname, key skey, string text)
    {
    if(skey == llGetOwner()) 
    {
      if(text == "[ main ]"){llMessageLinked(LINK_THIS, 0,"mainmenu_request","");}
      else if(text == ">>>") dialog_songmenu(cur_page+1);
      else if(text == "<<<") dialog_songmenu(cur_page-1);
      else if(llToLower(llGetSubString(text,0,5)) == "play #")
      {
        llMessageLinked(LINK_THIS,0,"erase_data",""); 
        string a = llLinksetDataRead("temp-"+llGetSubString(text,6,-1));  
        if(a == notecardName){ }else
        {
          if(readnote(a,1) == 2){llMessageLinked(LINK_THIS,0,"music_changed","");}
          dialog0();
          }
        }
      }  
    }
    link_message(integer sender_num, integer num, string msg, key id)
    {       
      list params = llParseString2List(msg, ["|"], []);
      if(msg == "holster"){if(aim_or_down_animation == TRUE){llSetTimerEvent(0); angle_anim("NULL");}}
      if(msg == "drawn"){if(aim_or_down_animation == TRUE){llSetTimerEvent(event_time);}}
      if(llList2String(params, 0) == "fetch_note_rationed")
      {
        if(readnote(llList2String(params,1),0) == 2)
        {
        llMessageLinked(LINK_THIS,0,"music_changed",""); 
        return;
        }
      }
      list item = llParseString2List(msg,["="],[]);
      if("search_engine"==llList2String(item,0)){ cur_page = 1; search_engine(llList2String(item,1)); dialog0(); }
      if(msg == "[ reset ]"){llResetScript();}
    }
    dataserver(key keyQueryId, string strData)
    {
    if (keyQueryId == keyConfigQueryhandle)
    {
          if (strData == EOF){llMessageLinked(LINK_THIS,0,"music_changed","");}else
          {
          keyConfigQueryhandle = llGetNotecardLine(note_name, ++intLine1);
          llMessageLinked(LINK_THIS,0,"upload_note|" + strData,"");
    }  }  }
    timer()
    {
    integer view = llGetAgentInfo(llGetOwner());
    if (view & AGENT_MOUSELOOK)
    {
    vector pos0 = llGetPos();  
    vector pos1 = pos0-<5.5,0,0>*llGetRot();
    float angle = pos0.z-pos1.z;
    aim_angle((integer)angle);
    }else{
    angle_anim("NULL");
    }
  }
}
