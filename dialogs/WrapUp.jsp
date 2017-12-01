<?xml version="1.0"?>
<%@ page import="java.util.*" %>

<%
  // This jsp is primarily designed to <prompt>
  // out the final confimation information.
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

    <form id="WrapUp">
      <block>
        <nuance:taskend name="sold_a_pizza" cond="true" reason=""/>
        <audio expr="PromptPath + 'i_got_a.wav'"/>
        <audio expr="PromptPath + PizzaSize + '.wav'"/>
        <audio expr="PromptPath + 'pizza_with.wav'"/>
        <%= toppingListStr %>
        <audio expr="PromptPath + 'to_be_delivered_to.wav'"/>
        <audio expr="PromptPath + '1380_Willow_Road.wav'"/>
        <audio src="pause:1000"/>
        <goto next="Goodbye.vxml"/>
      </block>
    </form>
</vxml>

