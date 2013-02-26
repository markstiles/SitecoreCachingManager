<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CacheUI.aspx.cs" Inherits="sitecore.admin.CacheUI" %>
<%@ Import Namespace="Sitecore.Data.Managers"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <style>
		.clear { clear:both; }
		* { color:#333; }
		body { background:url("/sitecore/shell/themes/standard/gradients/gray1.gif") repeat-y scroll 50% 0 #4E4E4E; margin:0px; padding:0px; }
		h1, h2, h3, h4 { padding: 5px; margin:5px; color:#fff; font-style:normal; font-family:Tahoma;}
		h1 { font-size:22px; font-family:Tahoma; font-weight:normal; }
		h2 { background: none repeat scroll 0 0 #D9D9D9; border-bottom: 1px solid #ccc; display:block; margin:0px;
                border-top: 1px solid #fff; color: #555555; font: bold 8pt tahoma; padding: 1px 2px; }
			h2 a { font-weight:normal; display:inline-block; margin-left:20px; }
		h3 { font-size:14px; background-color:#ccc; font-weight:normal; }
			h3 span { font-weight:normal; }
		h4 { margin: 5px 0; color:#444; }
			h4 span { font-size:12px; font-weight:normal; }
		.title { font-weight:bold; color:#444; }
		.spacer { background:#fff; height: 15px; border-right:1px solid #333; border-left:1px solid #333; }
		.ActiveRegion,
		.Region { background:#F0F1F2; border-right:1px solid #333; border-left:1px solid #333; border-bottom:1px solid #333; position:relative; }
		.Region { display:none; }
		.Section { }
		.ButtonSection { background-color:#cccccc; }
		.BtnClear { float:right; }
		.GlobalSearch, .SiteCacheList, .SiteProfileList, .DBCacheList, .DBProfileList, .ARCacheList, .ARProfileList, .MiscCacheList, .MiscProfileList { position:relative; }
		.Controls { padding:10px; font:8pt tahoma; }
			.fieldHighlight { border-left:4px solid #CCCCCC; padding-left:8px;}
			.dataRow { margin-bottom:5px; }
			.txtQuery { width:500px; margin-top:5px; }
			.btnSpacer { float:left; line-height:16px; }
			.rowSpacer { height:15px; }
			.Controls span { display:inline-block; margin-right:20px;}
			.GlobalSearch .ButtonSection span { display:inline-block; margin-left:30px; }
		.CacheSiteForm, .CacheList, .ProfileList, .GlobalSearch { }
			.CacheSiteForm .Section { display:none;}
			.CacheSiteForm a { margin:10px 0; font-size:12px; color:#000; }
			.CacheSiteForm .Section { padding:0px 5px; background:none; } 
		.CacheList {  }
			.ProfileList .Section, .CacheList .Section, .ButtonSection, .GlobalSearch .Section { padding:0px 5px 5px; background:none; display:block; }
			.ResultTitle { margin-bottom: 5px; padding: 0 5px; }
			.Results { background:#fff; border:2px groove #f0f0f0; margin-bottom: 5px; max-height: 350px; overflow: auto; padding: 0 5px;}
			.FormTitleRow { clear:both; padding:0 5px 5px; }
			.FormRow { clear:both; border-bottom:1px dashed #ccc; margin-bottom:3px; padding-bottom:3px; }
			.RowTitle { float:left; font-weight:bold; }
				.Results .RowTitle { font-style:italic; }
			.RowValue { float:left; }
			.CacheName { width:175px; }
			.CacheKey {  }
			.Name { width: 250px }
			.Count { width: 150px }
			.Size { width: 150px }
			.MaxSize { width: 150px }
		.CacheItems { margin:0 10px 0 20px; }
		.overlay { padding-top:40px; display:none; position:absolute; top:0px; bottom:0px; right:0px; left:0px; text-align:center; background-color:#ffffff; filter:alpha(opacity=60); opacity:0.6; }
			.overlay .message { position:absolute; top:40px; width:100%; color:#333; font-family:Tahoma; font-size:19px; font-weight:bold; }
	    /*Sitecorey styles */
	    #EditorTabs { height: 24px; vertical-align: top;
            background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab7.png") repeat-x scroll 0 0 #888888;
        }
            .activeTab { color: black; float: left; height: 24px; outline: medium none; padding: 0; text-decoration: none; white-space: nowrap; }
            .normalTab { }
                .tabOpen { /* */ }
				.firstTab .tabOpen { float: left; width:6px; height:24px;
				    background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab0.png") no-repeat 0 0; }
                .activeTab .tabOpen { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab0_h.png") no-repeat 0 0; }
                .tabInfo { float:left; height:24px; padding:4px 0 0; 
                    background: url("/sitecore/shell/Themes/Standard/Images/Ribbon/tab1.png") repeat-x 0 0;    
                }
                .activeTab .tabInfo { background: url("/sitecore/shell/Themes/Standard/Images/Ribbon/tab1_h.png") repeat-x 0 0; }
                    .tabIcon { width:16px; height:16px; margin: 0 2px 0 0; vertical-align: middle; }
                    .tabInfo span { color:#333; font:8pt tahoma; }
                    .tabInfo img { padding-right:5px; float:left; display:inline-block; }
                .tabClose { float:left; height:24px; width: 21px; 
                    background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab2.png") no-repeat 0 0;
                }
                .activeTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab2_h1.png") no-repeat 0 0 }
				.prevTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab2_h2.png") no-repeat 0 0 }
				.lastTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab3.png") no-repeat 0 0 }
				.activeTab.lastTab .tabClose { background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab3_h.png") no-repeat 0 0 }
				
            .btnBox { display:inline-block; height:20px; margin:5px 0; }
		        .btnMessage { float:left; padding:9px 0px 15px 5px; margin:1px; }
		        .btn { float:left; padding: 3px 4px 3px 9px; margin:1px; }
		        .btn:hover { background: url("/sitecore/shell/themes/standard/images/Ribbon/SmallButtonActive.png") repeat-x scroll 0 0 #fffbd3; 
                    border-style:solid; border-width:1px; border-color:#ddcf9b #d2c08e #ccc2a3; margin:0px;             
                }
		            .btn img { float:left; }
		            .btn input,
		            .btn a { color:#303030; font-family: tahoma; font-size: 8pt; border:none; background:none; 
		                            float:left; height:15px; padding:0 0 3px 20px; 
                    }
                        
						.btn a.toggle { padding-right:4px; text-decoration:none; background: url('/sitecore/shell/themes/standard/Images/expand15x15.gif') no-repeat 0 0; }
                        <%= SearchBtn %>
		                <%= BtnClear %>
		                <%= ClearAll %>
		                <%= SelectAll %>
		                <%= ProfileBtn %>
		                <%= Summary %>
	</style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function () {
    		var allTabs = ".normalTab, .activeTab";
    		$(allTabs).click(function (e) {
    			e.preventDefault();
    			if ($(this).attr("class").indexOf("normalTab") > -1) {
    				//sort out active and normal tabs
    				$(".activeTab").removeClass("activeTab").addClass("normalTab");
    				$(this).removeClass("normalTab").addClass("activeTab");
    				//sort out prev tab
    				$(".prevTab").removeClass("prevTab");
    				var prev = $(this).prev();
    				if (prev != null)
    					$(prev).addClass("prevTab");
    				var newRegion = $(this).attr("rel");
    				$(".ActiveRegion").removeClass("ActiveRegion").addClass("Region");
    				$("." + newRegion).removeClass("Region").addClass("ActiveRegion");
    			}
    		});
    		$('h2').dblclick(function () {
    			$(this).next(".Controls").toggle();
    		});
    	});
    	var IsSiteChecked = false;
    	function CheckAll(link, cssClass) {
    		var split = "";
    		var join = ""
    		if ($(link).text().indexOf("deselect") >= 0) {
    			split = "deselect";
    			join = "select";
    			IsSiteChecked = false;
    		} else {
    			split = "select";
    			join = "deselect";
    			IsSiteChecked = true;
    		}

    		var newText = $(link).text().split(split).join(join);
    		$(link).text(newText);

    		$("." + cssClass + " input:checkbox").each(function () {
    			$(this).attr('checked', IsSiteChecked);
    		});
    	}
    	var OverlayObject;
    	function beginRequest(sender, args) {
    		var clientId = args.get_postBackElement().id;
    		var wrapper = $("#" + clientId).attr("rel");
    		OverlayObject = $(wrapper).find(".overlay");
    		$(OverlayObject).css("display", "block");
    	}
    	function endRequest(sender, args) {
    		$(OverlayObject).css("display", "none");
    	}
    </script>
</head>
<body>
    <form id="form1" defaultbutton="btnGQuery" runat="server">
		<asp:ScriptManager ID="scriptManager" runat="server"></asp:ScriptManager>
		<script type="text/javascript" language="javascript">
			Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequest);
			Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequest);
        </script>
		<h1>Caching Manager</h1>
		<div id="EditorTabs">
            <a class="activeTab firstTab" href="#" rel="GlobalRegion">
                <div class="tabOpen"></div>
                <div class="tabInfo">
                    <asp:Image runat="server" ID="imgGlobal" />
                    <span>Global Search</span>
                </div>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab" href="#" rel="SiteRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgSite" />
                    <span>Caches By Site</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab" href="#" rel="DatabaseRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgDB" />
                    <span>Caches By Database</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab" href="#" rel="ARRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgAR" />
                    <span>Access Result Caches</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab lastTab" href="#" rel="MiscRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <asp:Image runat="server" ID="imgMisc" />
                    <span>Access Result Caches</span>
                </span>
                <div class="tabClose"></div>
            </a>
        </div>
        <div class="spacer">&nbsp;</div>
        <div class="ActiveRegion GlobalRegion">
			<asp:UpdatePanel ID="upGQuery" runat="server" UpdateMode="Conditional">
				<ContentTemplate>
                    <h2>Cache Information</h2>
			        <div class="Controls">
						<div class="dataRow">
                            Total Cache Size: <span class="title"><asp:Literal ID="ltlSize" runat="server"></asp:Literal></span>
						</div>
                        <div class="dataRow">
                            Cache Entries: <span class="title"><asp:Literal ID="ltlEntries" runat="server"></asp:Literal></span>
						</div>
                        <div class="clear"></div>
			        </div>
                    <h2>Cache Search</h2>
                    <div class="Controls">
                        <div class="fieldHighlight">
                            <asp:TextBox ID="txtGQuery" CssClass="txtQuery" runat="server"></asp:TextBox>				
						    <div class="clear"></div>    
                        </div>
                        <div class="rowSpacer"></div>
                        <div class="fieldHighlight">
							<div class="btnBox">
                                <div class="btn">
                                    <asp:Button ID="btnGQuery" CssClass="searchBtn" rel=".GlobalRegion" Text="Search All Cache" runat="server" OnClick="btnGQuery_Click" />        
                                </div>
                                <div class="btnSpacer">.</div>
                                <div class="btn">
                                    <asp:Button ID="btnGQueryClear" rel=".GlobalRegion" CssClass="BtnClear" Text="Clear Search Results" runat="server" OnClick="btnGQueryClear_Click" />
                                </div>
                                <div class="btnSpacer">.</div>
                                <div class="btn">
                                    <asp:button ID="c_clearAll" rel=".GlobalRegion" CssClass="clearAllBtn" runat="server" Text="Clear All Cache" OnClick="c_clearAll_Click"></asp:button>
						        </div>
                            </div>
                            <div class="clear"></div>
							<div class="btnMessage">
								<asp:Literal ID="ltlResults" runat="server"></asp:Literal>
							</div>
					        <asp:Repeater ID="rptGQuery" runat="server">
						        <HeaderTemplate>
									<div class="FormTitleRow">
										<div class="CacheName RowTitle">Cache Name</div>
										<div class="CacheKey RowTitle">Cache Key</div>
										<div class="clear"></div>
									</div>
							        <div class="Results GlobalResults">
						        </HeaderTemplate>
						        <ItemTemplate>
							        <div class="FormRow">
								        <div class="CacheName RowValue">
									        <%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Text %>
								        </div>
								        <div class="CacheKey RowValue">
									        <%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Value %>
								        </div>
								        <div class="clear"></div>
							        </div>
						        </ItemTemplate>
						        <FooterTemplate></div></FooterTemplate>
					        </asp:Repeater>
                        </div>
                    </div>
				</ContentTemplate>
			</asp:UpdatePanel>
			<div class="overlay"><div class="message">Loading...</div></div>
			<div class="clear"></div>
		</div>
		<div class="Region SiteRegion">			
            <h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow">
						<div class="RowTitle">Type</div>
					</div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'SiteTypeChecks');return false;">select all - (choose at least one)</a>
						</div>
					</div>
					<div class="SiteTypeChecks">
						<asp:CheckBoxList ID="cblSiteTypes" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="rowSpacer"></div>
				<div class="fieldHighlight">
					<div class="FormTitleRow">
						<div class="RowTitle">System Names </div>
					</div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'SysChecks');return false;">select all - (choose at least one of either system or site name)</a>
						</div>
					</div>
					<div class="SysChecks">
						<asp:CheckBoxList ID="cblSysSiteNames" RepeatColumns="12" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="rowSpacer"></div>
				<div class="fieldHighlight">
					<div class="FormTitleRow">
						<div class="RowTitle">Site Names</div>
					</div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'SiteChecks');return false;">select all</a>
						</div>					
					</div>
					<div class="SiteChecks">
						<asp:CheckBoxList ID="cblSiteNames" RepeatColumns="10" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel2" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="btnFetch" rel=".SiteRegion" CssClass="summary" runat="server" Text="Get Summary" OnClick="FetchSiteCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button6" rel=".SiteRegion" CssClass="profile" runat="server" Text="Get Cache Entries" OnClick="FetchSiteCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button8" rel=".SiteRegion" CssClass="BtnClear" runat="server" Text="Clear Cache Entries" OnClick="ClearSiteCacheProfile"></asp:button>
								</div>
							</div>
							<div class="CacheList SiteCacheList">
								<asp:Repeater ID="rptSiteCaches" runat="server">
									<HeaderTemplate>
										<div class="FormTitleRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
											<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
											<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
											<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
											<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
											<div class="clear"></div>
										</div>	
									</ItemTemplate>
									<FooterTemplate>
										</div>
									</FooterTemplate>
								</asp:Repeater>
							</div>
							<div class="ProfileList SiteProfileList">
								<asp:Repeater ID="rptSiteCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
									<HeaderTemplate>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow">
											<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
												<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
												<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
												<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
											</h4>
											<div class="CacheItems">
												<asp:Repeater ID="rptBySite" runat="server">
													<HeaderTemplate>
														<div class="FormRow">
															<div class="CacheID RowTitle">Cache ID</div>
															<div class="clear"></div>
														</div>
													</HeaderTemplate>
													<ItemTemplate>
														<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
															<div class="CacheID"><%# Container.DataItem %></div>
														</div>
													</ItemTemplate>
												</asp:Repeater>
											</div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>	
							</div>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>	
			</div>
		</div>
		<div class="Region DatabaseRegion">
			<h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Types</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'DBTypeChecks');return false;">select all (choose at least one)</a>
						</div>
					</div>
					<div class="DBTypeChecks">
						<asp:CheckBoxList ID="cblDBTypes" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="rowSpacer"></div>
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Database Names</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'DBChecks');return false;">select all (choose at least one of either system or site name)</a>
						</div>
					</div>
					<div class="DBChecks">
						<asp:CheckBoxList ID="cblDBNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel4" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="Button1" rel=".DatabaseRegion" class="summary" runat="server" Text="Get Summary" OnClick="FetchDBCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button5" rel=".DatabaseRegion" class="profile" runat="server" Text="Get Cache Entries" OnClick="FetchDBCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button10" rel=".DatabaseRegion" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearDBCacheProfile"></asp:button>
								</div>
							</div>
							<div class="CacheList DBCacheList">
								<asp:Repeater ID="rptDBCaches" runat="server">
									<HeaderTemplate>
										<div class="FormTitleRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
											<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
											<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
											<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
											<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
											<div class="clear"></div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
							<div class="ProfileList DBProfileList">
								<asp:Repeater ID="rptDBCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
									<HeaderTemplate><div class="Results"></HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow">
											<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
												<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
												<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
												<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
											</h4>
											<div class="CacheItems">
												<asp:Repeater ID="rptBySite" runat="server">
													<HeaderTemplate>
														<div class="FormRow">
															<div class="CacheID RowTitle">Caching ID</div>
															<div class="clear"></div>
														</div>
													</HeaderTemplate>
													<ItemTemplate>
														<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
															<div class="CacheID"><%# Container.DataItem %></div>
														</div>
													</ItemTemplate>
												</asp:Repeater>
											</div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>
			</div>
		</div>
		<div class="Region ARRegion">
			<h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Cache Names</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn"> 
							<a href="#" class="selectAll" onclick="CheckAll(this, 'MiscChecks');return false;">select all (choose at least one)</a>						
						</div>
					</div>
					<div class="MiscChecks">
						<asp:CheckBoxList ID="cblAccessResult" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel64" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="Button2" rel=".ARRegion" class="summary" runat="server" Text="Get Summary" OnClick="FetchARCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button7" rel=".ARRegion" class="profile" runat="server" Text="Get Cache Entries" OnClick="FetchARCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button11" rel=".ARRegion" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearARCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer"></div>
							</div>
						</div>
						<div class="CacheList ARCacheList">	
							<asp:Repeater ID="rptARCaches" runat="server">
							<HeaderTemplate>
								<div class="FormTitleRow">
									<div class="Name RowTitle">Name</div>
									<div class="Count RowTitle">Cache Entries</div>
									<div class="Size RowTitle">Size</div>
									<div class="MaxSize RowTitle">MaxSize</div>
									<div class="clear"></div>
								</div>
								<div class="Results">
							</HeaderTemplate>
							<ItemTemplate>
								<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
									<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
									<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
									<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
									<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
									<div class="clear"></div>
								</div>	
							</ItemTemplate>
							<FooterTemplate></div></FooterTemplate>
						</asp:Repeater>
						</div>
						<div class="ProfileList ARProfileList">
							<asp:Repeater ID="rptARCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
								<HeaderTemplate><div class="Results"></HeaderTemplate>
								<ItemTemplate>
									<div class="FormRow">
										<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
											<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
											<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
											<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
										</h4>
										<div class="CacheItems">
											<asp:Repeater ID="rptBySite" runat="server">
												<HeaderTemplate>
													<div class="FormRow">
														<div class="CacheID RowTitle">Caching ID</div>
														<div class="clear"></div>
													</div>
												</HeaderTemplate>
												<ItemTemplate>
													<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
														<div class="CacheID"><%# Container.DataItem %></div>
													</div>
												</ItemTemplate>
											</asp:Repeater>
										</div>
									</div>
								</ItemTemplate>
								<FooterTemplate></div></FooterTemplate>
							</asp:Repeater>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>
			</div>
		</div>
		<div class="Region MiscRegion">
			<h2>Search Criteria</h2>
			<div class="Controls">
				<div class="fieldHighlight">
					<div class="FormTitleRow"><div class="RowTitle">Cache Names</div></div>
					<div class="clear"></div>
					<div class="btnBox">
						<div class="btn">
							<a href="#" class="selectAll" onclick="CheckAll(this, 'MiscChecks');return false;">select all (choose at least one)</a> 
						</div>
					</div>
					<div class="MiscChecks">
						<asp:CheckBoxList ID="cblMiscNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<h2>Search Results</h2>
			<div class="Controls">
				<asp:UpdatePanel ID="UpdatePanel6" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="fieldHighlight">
							<div class="btnBox">
								<div class="btn">
									<asp:button ID="Button3" rel=".MiscRegion" class="summary" runat="server" Text="Get Summary" OnClick="FetchMiscCacheList"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button4" rel=".MiscRegion" class="profile" runat="server" Text="Get Cache Entries" OnClick="FetchMiscCacheProfile"></asp:button>
								</div>
								<div class="btnSpacer">.</div>
								<div class="btn">
									<asp:button ID="Button13" rel=".MiscRegion" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearMiscCacheProfile"></asp:button>
								</div>
							</div>
							<div class="CacheList MiscCacheList">
								<asp:Repeater ID="rptMiscCaches" runat="server">
									<HeaderTemplate>
										<div class="FormTitleRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
										<div class="Results">
									</HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
											<div class="Name RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %></div>
											<div class="Count RowValue"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></div>
											<div class="Size RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></div>
											<div class="MaxSize RowValue"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></div>
											<div class="clear"></div>
										</div>	
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
							<div class="ProfileList MiscProfileList">
								<asp:Repeater ID="rptMiscCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
									<HeaderTemplate><div class="Results"></HeaderTemplate>
									<ItemTemplate>
										<div class="FormRow">
											<h4><%# ((Sitecore.Caching.Cache)Container.DataItem).Name %> - 
												<span>Cache Entries:</span> <span class="title"><%# ((Sitecore.Caching.Cache)Container.DataItem).Count %></span>
												<span>Size:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).Size) %></span>
												<span>MaxSize:</span> <span class="title"><%# GetValFromB(((Sitecore.Caching.Cache)Container.DataItem).MaxSize) %></span>
											</h4>
											<div class="CacheItems">
												<asp:Repeater ID="rptBySite" runat="server">
													<HeaderTemplate>
														<div class="FormRow">
															<div class="CacheID RowTitle">Caching ID</div>
															<div class="clear"></div>
														</div>
													</HeaderTemplate>
													<ItemTemplate>
														<div class="FormRow <%# GetClass(Container.ItemIndex) %>">
															<div class="CacheID"><%# Container.DataItem %></div>
														</div>
													</ItemTemplate>
												</asp:Repeater>
											</div>
										</div>
									</ItemTemplate>
									<FooterTemplate></div></FooterTemplate>
								</asp:Repeater>
							</div>
						</div>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay"><div class="message">Loading...</div></div>
			</div>
		</div>
    </form>
</body>
</html>