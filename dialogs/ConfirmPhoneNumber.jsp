<?xml version="1.0"?>

<%
  // This jsp is primarily designed to <prompt>
  // out the confimation phone number.
  // This same operation could have been done with the
  // VBS extension to play an array of audio URLs via
  // <audio expr="url_array"> extension.  Please see
  // the platform reference documentation for more
  // details.

  // input vars
  String phone_num = request.getParameter("phone");

  if (phone_num == null) {
    phone_num = "6508477738";
  }

  // output vars
  String phoneListStr = "";

  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(0) + ".wav'\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(1) + ".wav'\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(2) + "-mid.wav'\"/>\n";
  phoneListStr += "<audio src=\"pause:150\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(3) + ".wav'\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(4) + ".wav'\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(5) + "-mid.wav'\"/>\n";
  phoneListStr += "<audio src=\"pause:150\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(6) + ".wav'\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(7) + "-mid.wav'\"/>\n";
  phoneListStr += "<audio src=\"pause:100\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(8) + ".wav'\"/>\n";
  phoneListStr += "<audio expr=\"PromptPath + '" + phone_num.charAt(9) + "-end.wav'\"/>\n";
%>

<!DOCTYPE vxml PUBLIC "-//Nuance/DTD VoiceXML 2.0//EN" "http://voicexml.nuance.com/dtd/nuancevoicexml-2-0.dtd">

<vxml version="2.0" application="pizza.vxml">

    <form id="ConfirmPhoneNumber">
      <var name="entry" expr="'init'"/>

      <field name="confirm">
        <property name="nuance.grammarlabel" value="ConfirmPhoneNumber"/>
        <prompt cond="entry == 'init'">
          <audio expr="PromptPath + 'i_heard.wav'"/>
          <%= phoneListStr %>
          <audio expr="PromptPath + 'i_got_that_right.wav'"/>
        </prompt>
        <prompt cond="entry == 'rej'">
          <audio expr="PromptPath + 'ConfirmPhoneNumber_rej.wav'"/>
          <%= phoneListStr %>
        </prompt>
        <prompt cond="entry == 'nst'">
          <audio expr="PromptPath + 'ConfirmPhoneNumber_nst.wav'"/>
          <%= phoneListStr %>
        </prompt>
        <prompt cond="entry == 'help'">
          <audio expr="PromptPath + 'ConfirmPhoneNumber_help.wav'"/>
          <%= phoneListStr %>
        </prompt>

        <grammar src="../grammars/Confirm.grxml#Confirm"/>
        <filled>
          <if cond="confirm == 'yes'">
            <audio expr="PromptPath + 'GotAddress.wav'"/>
            <goto next="ConfirmDeliveryNow.vxml"/>
          <else/>
            <goto next="GetPhoneNumber.vxml#reentry"/>
          </if>
        </filled>
      </field>
    </form>
</vxml>

