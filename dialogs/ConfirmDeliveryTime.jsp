<?xml version="1.0"?>

<%
  // This jsp is primarily designed to <prompt>
  // out the delivery time.
  // This same operation could have been done with the
  // VBS extension to play an array of audio URLs via
  // <audio expr="url_array"> extension.  Please see
  // the platform reference documentation for more
  // details.

  // input vars
  String time = request.getParameter("time");

  if (time == null) {
    time = "2000";
  }

  // output vars
  String timeStr = "";

  int hour;
  int min;

  if (time.length() <= 2) {
    hour = 0;
    min = Integer.parseInt(time);
  } else if (time.length() == 3) {
    hour = Integer.parseInt(time.substring(0,1));
    min = Integer.parseInt(time.substring(1,3));
  } else {
    hour = Integer.parseInt(time.substring(0,2));
    min = Integer.parseInt(time.substring(2,4));
  }

  if (hour >= 12) {  // pm
    if (hour != 12) {
      hour -= 12;
    }
    timeStr += "<audio expr=\"PromptPath + '" + hour + ".wav'\"/>\n";
    if (min != 0) {
      if (min < 10) {
        timeStr += "<audio expr=\"PromptPath + '0.wav'\"/>\n";
        timeStr += "<audio expr=\"PromptPath + '" + min + ".wav'\"/>\n";
      } else {
        timeStr += "<audio expr=\"PromptPath + '" + min + ".wav'\"/>\n";
      }
    }
    timeStr += "<audio expr=\"PromptPath + 'pm.wav'\"/>\n";
  } else {
    if (hour == 0) {
      hour = 12;
    }
    timeStr += "<audio expr=\"PromptPath + '" + hour + ".wav'\"/>\n";
    if (min != 0) {
      if (min < 10) {
        timeStr += "<audio expr=\"PromptPath + '0.wav'\"/>\n";
        timeStr += "<audio expr=\"PromptPath + '" + min + ".wav'\"/>\n";
      } else {
        timeStr += "<audio expr=\"PromptPath + '" + min + ".wav'\"/>\n";
      }
    }
    timeStr += "<audio expr=\"PromptPath + 'am.wav'\"/>\n";
  }

%>

<!DOCTYPE vxml PUBLIC "-//Nuance/DTD VoiceXML 2.0//EN" "http://voicexml.nuance.com/dtd/nuancevoicexml-2-0.dtd">

<vxml version="2.0" application="pizza.vxml">

    <form id="ConfirmDeliveryTime">
      <var name="entry" expr="'init'"/>

      <field name="confirm">
        <property name="nuance.grammarlabel" value="ConfirmDeliveryTime"/>
        <prompt cond="entry == 'init'">
          <audio expr="PromptPath + 'ConfirmDeliveryTime_inita.wav'"/>
          <%= timeStr %>
          <audio expr="PromptPath + 'ConfirmDeliveryTime_initb.wav'"/>
        </prompt>
        <prompt cond="entry == 'rej'">
          <audio expr="PromptPath + 'ConfirmDeliveryTime_rej.wav'"/>
          <%= timeStr %>
          <audio expr="PromptPath + 'ConfirmDeliveryTime_initb.wav'"/>
        </prompt>
        <prompt cond="entry == 'nst'">
          <audio expr="PromptPath + 'ConfirmDeliveryTime_nst.wav'"/>
          <%= timeStr %>
          <audio expr="PromptPath + 'ConfirmDeliveryTime_initb.wav'"/>
        </prompt>
        <prompt cond="entry == 'help'">
          <audio expr="PromptPath + 'ConfirmDeliveryTime_help.wav'"/>
          <%= timeStr %>
          <audio expr="PromptPath + 'ConfirmDeliveryTime_initb.wav'"/>
        </prompt>

        <grammar src="../grammars/Confirm.grxml#Confirm"/>
        <filled>
          <if cond="confirm == 'yes'">
            <goto expr="'WrapUp.jsp?toppings=' + PizzaToppings"/>
          <else/>
            <goto next="GetDeliveryTime.vxml"/>
          </if>
        </filled>
      </field>
    </form>
</vxml>

