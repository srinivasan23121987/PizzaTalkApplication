<?xml version="1.0"?>
<%@ page import="java.util.*" %>

<%
  // This jsp is primarily designed to <prompt>
  // out the confimation size and toppings.
  // This same operation could have been done with the
  // VBS extension to play an array of audio URLs via
  // <audio expr="url_array"> extension.  Please see
  // the platform reference documentation for more
  // details.

  // input vars
  String toppings = request.getParameter("toppings");

  if (toppings == null) {
    toppings = "mushrooms|onions";
  }

  // output vars
  String toppingListStr = "";

  StringTokenizer stok = new StringTokenizer(toppings, "|");
  int n = stok.countTokens();

  if (n == 0) {
    toppingListStr = "<audio expr=\"PromptPath + 'plain.wav'\"/>";
  }
  if (n == 1) {
    toppingListStr = "<audio expr=\"PromptPath + '" + stok.nextToken() + ".wav'\"/>";
  }
  if (n > 1) {
    for(int i=0;i<n-1;i++) {
      toppingListStr += "<audio expr=\"PromptPath + '" + stok.nextToken() + ".wav'\"/>\n";
    }
    toppingListStr += "<audio expr=\"PromptPath + 'and.wav'\"/>\n";
    toppingListStr += "<audio expr=\"PromptPath + '" + stok.nextToken() + ".wav'\"/>";
  }
%>

<!DOCTYPE vxml PUBLIC "-//Nuance/DTD VoiceXML 2.0//EN" "http://voicexml.nuance.com/dtd/nuancevoicexml-2-0.dtd">

<vxml version="2.0" application="pizza.vxml">

    <form id="ConfirmSizeAndToppings">
      <var name="entry" expr="'init'"/>

      <field name="confirm">
        <property name="nuance.grammarlabel" value="ConfirmSizeAndToppings"/>
        <prompt cond="entry == 'init'">
          <audio expr="PromptPath + 'you_wanna.wav'"/>
          <audio expr="PromptPath + PizzaSize + '.wav'"/>
          <audio expr="PromptPath + 'pizza_with.wav'"/>
          <%= toppingListStr %>
          <audio expr="PromptPath + 'is_that_right.wav'"/>
        </prompt>
        <prompt cond="entry == 'rej'">
          <audio expr="PromptPath + 'didnt_get_that.wav'"/>
          <audio expr="PromptPath + 'you_wanna.wav'"/>
          <audio expr="PromptPath + PizzaSize + '.wav'"/>
          <audio expr="PromptPath + 'pizza_with.wav'"/>
          <%= toppingListStr %>
          <audio expr="PromptPath + 'is_that_right.wav'"/>
        </prompt>
        <prompt cond="entry == 'nst'">
          <audio expr="PromptPath + 'didnt_get_that.wav'"/>
          <audio expr="PromptPath + 'you_wanna.wav'"/>
          <audio expr="PromptPath + PizzaSize + '.wav'"/>
          <audio expr="PromptPath + 'pizza_with.wav'"/>
          <%= toppingListStr %>
          <audio expr="PromptPath + 'is_that_right.wav'"/>
        </prompt>
        <prompt cond="entry == 'help'">
          <audio expr="PromptPath + 'tell_me_yes_or_no_or_say_cancel_to_start_over_capisce.wav'"/>
          <audio expr="PromptPath + 'you_wanna.wav'"/>
          <audio expr="PromptPath + PizzaSize + '.wav'"/>
          <audio expr="PromptPath + 'pizza_with.wav'"/>
          <%= toppingListStr %>
          <audio expr="PromptPath + 'is_that_right.wav'"/>
        </prompt>

        <grammar src="../grammars/Confirm.grxml#Confirm"/>
        <filled>
          <if cond="confirm == 'yes'">
            <goto next="GetPhoneNumber.vxml"/>
          <else/>
            <goto next="#ConfirmTryAgain"/>
          </if>
        </filled>
      </field>
    </form>

    <form id="ConfirmTryAgain">
      <var name="entry" expr="'init'"/>

      <field name="confirm">
        <property name="nuance.grammarlabel" value="ConfirmTryAgain"/>
        <prompt cond="entry == 'init'">
          <audio expr="PromptPath + 'WouldYouLikeToTryAgain.wav'"/>
        </prompt>
        <prompt cond="entry == 'rej'">
          <audio expr="PromptPath + 'didnt_get_that.wav'"/>
          <audio expr="PromptPath + 'WouldYouLikeToTryAgain.wav'"/>
        </prompt>
        <prompt cond="entry == 'nst'">
          <audio expr="PromptPath + 'sorry_i_couldnt_hear_you.wav'"/>
          <audio expr="PromptPath + 'WouldYouLikeToTryAgain.wav'"/>
        </prompt>
        <prompt cond="entry == 'help'">
          <audio expr="PromptPath + 'didnt_get_that.wav'"/>
          <audio expr="PromptPath + 'WouldYouLikeToTryAgain.wav'"/>
        </prompt>

        <grammar src="../grammars/Confirm.grxml#Confirm"/>
        <filled>
          <if cond="confirm == 'yes'">
            <goto next="ChangeSizeOrToppings.vxml"/>
          <else/>
            <nuance:taskend name="sold_a_pizza"
                            cond="false" reason="User did not confirm"/>
            <goto next="Goodbye.vxml"/>
          </if>
        </filled>
      </field>
    </form>
</vxml>

