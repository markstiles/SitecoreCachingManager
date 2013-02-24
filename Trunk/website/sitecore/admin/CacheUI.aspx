<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CacheUI.aspx.cs" Inherits="sitecore.admin.CacheUI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
    <style>
		.clear { clear:both; }
		* { color:#333; }
		body { background:url("/sitecore/shell/themes/standard/gradients/gray1.gif") repeat-y scroll 50% 0 #4E4E4E; margin:0px; padding:0px; }
		h1, h2, h3, h4 { padding: 5px; margin:5px; color:#666; font-style:normal;}
		h1 { font-size:16px; }
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
		.Region { background:#F0F1F2; border-right:1px solid #333; border-left:1px solid #333; border-bottom:1px solid #333; }
		.Region { display:none; }
		.Section { }
		.ButtonSection { background-color:#cccccc; }
		.BtnClear { float:right; }
		.GlobalSearch, .SiteCacheList, .SiteProfileList, .DBCacheList, .DBProfileList, .ARCacheList, .ARProfileList, .MiscCacheList, .MiscProfileList { position:relative; }
		.GlobalControls { padding:10px; font:8pt tahoma; }
			.fieldHighlight { border-left:4px solid #CCCCCC; padding-left:8px;}
			.dataRow { margin-bottom:5px; }
			.txtQuery { width:500px; margin-top:5px; }
			.btnSpacer { float:left; }
			.rowSpacer { height:15px; }
			.GlobalControls span { display:inline-block; margin-right:20px;}
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
			.RowValue { float:left; }
			.CacheName { width:175px; }
			.CacheKey {  }
			.Name { width: 250px }
			.Count { width: 150px }
			.Size { width: 150px }
			.MaxSize { width: 150px }
		.CacheItems { margin:0 10px 0 20px; }
			.CacheItems .FormRow, .CacheList .FormRow, .GlobalSearch .FormRow { margin:5px 0; padding:5px; background-color:#ccc; border:1px solid #888888;}
		.even { background-color:#bbb; }
		.odd { background-color:#ccc; }
		.overlay { padding-top:10px; display:none; position:absolute; top:0px; bottom:0px; right:0px; left:0px; text-align:center; background-color:#ffffff; filter:alpha(opacity=60); opacity:0.6; }
	    /*Sitecorey styles */
	    #EditorTabs { height: 24px; vertical-align: top;
            background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab7.png") repeat-x scroll 0 0 #888888;
        }
            .activeTab { color: black; float: left; height: 24px; outline: medium none; padding: 0; text-decoration: none; white-space: nowrap; }
            .normalTab { }
                .tabOpen { float: left; }
                .tabClose { height:24px; width: 21px; 
                    background: url("http://testsite650/sitecore/shell/themes/standard/Images/Ribbon/tab3.png") no-repeat 0 0;
                }
                .activeTab .tabOpen { float: left; height: 24px; width: 6px;
                    background: url("/sitecore/shell/themes/standard/Images/Ribbon/tab0_h.png") no-repeat 0 0; }
                
                .tabInfo { float:left; height:24px; padding:2px 0 0; 
                    background: url("/sitecore/shell/Themes/Standard/Images/Ribbon/tab1.png") repeat-x 0 0;    
                }
                .activeTab .tabInfo { 
                    background: url("/sitecore/shell/Themes/Standard/Images/Ribbon/tab1_h.png") repeat-x 0 0;    
                }
                    .tabIcon { width:16px; height:16px; margin: 0 2px 0 0; vertical-align: middle; }
                    .tabInfo span { color:#333; font:8pt tahoma; }
                .tabClose { float:left; height:24px; width:21px; }
                .activeTab .tabClose { background: url("http://testsite650/sitecore/shell/themes/standard/Images/Ribbon/tab2_h1.png") no-repeat 0 0 }
            
            .btnBox { display:inline-block; height:20px; margin:5px 0; }
		        .btnMessage { float:left; padding: 3px 4px 3px 9px; margin:1px; }
		        .btn { float:left; padding: 3px 4px 3px 9px; margin:1px; }
		        .btn:hover { background: url("/sitecore/shell/themes/standard/images/Ribbon/SmallButtonActive.png") repeat-x scroll 0 0 #fffbd3; 
                    border-style:solid; border-width:1px; border-color:#ddcf9b #d2c08e #ccc2a3; margin:0px;             
                }
		            .btn img { float:left; }
		            .btn input,
		            .btn a { color:#303030; font-family: tahoma; font-size: 8pt; border:none; background:none; 
		                            float:left; height:14px; padding-left:20px;
                    }
                        .btn a.toggle { padding-right:4px; text-decoration:none; background: url('/sitecore/shell/themes/standard/Images/expand15x15.gif') no-repeat 0 0; }
                        .btn input.searchBtn { background: url('/temp/IconCache/Applications/16x16/view.png') no-repeat 0 0; }
		                .btn input.BtnClear { background: url('/temp/IconCache/Applications/16x16/recycle.png') no-repeat 0 0; }
		                .btn input.clearAllBtn { background: url('/temp/IconCache/Applications/16x16/refresh.png') no-repeat 0 0; }
	</style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            var allTabs = ".normalTab, .activeTab";
            $(allTabs).click(function (e) {
                console.log("1");
                e.preventDefault();
                console.log("2");
                if ($(this).attr("class").indexOf("normalTab") > -1) {
                    console.log("3");
                
                    $(allTabs).attr("class", "normalTab");
                    $(this).attr("class", "activeTab");
                    var newRegion = $(this).attr("rel");
                    $(".ActiveRegion").removeClass("ActiveRegion").addClass("Region");
                    $("." + newRegion).removeClass("Region").addClass("ActiveRegion");
                }
            });
        });
		var IsSiteChecked = false;
		function CheckAll(link, cssClass){
			if($(link).text().indexOf("deselect") != -1){
				$(link).text("select all");
				IsSiteChecked = false;
			} else {
				$(link).text("deselect all");
				IsSiteChecked = true;
			}
			
			$("." + cssClass + " input:checkbox").each(function(){
				$(this).attr('checked', IsSiteChecked);
			});
		}
		function CollapseSections(link, where) {
			$(link).parent().parent().find(where).each(function() {
				$(this).toggle();
			});
        }
        function CollapseNew(link, where) {
            $(where).toggle();
            var text = $(link).text();
            var newText = (text.indexOf("Collapse") != -1)
                ? text.split("Collapse").join("Expand")
                : text.split("Expand").join("Collapse");
            $(link).text(newText);
        }
		var OverlayObject;
		function beginRequest(sender, args){
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
            <a class="activeTab" href="#" rel="GlobalRegion">
                <div class="tabOpen"></div>
                <div class="tabInfo">
                    <img class="tabIcon" src="/temp/IconCache/People/16x16/cube_blue.png">
                    <span>Global Search</span>
                </div>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab lastTab" href="#" rel="SiteRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <img class="tabIcon" src="/temp/IconCache/People/16x16/cube_blue.png">
                    <span>Caches By Site</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab lastTab" href="#" rel="DatabaseRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <img class="tabIcon" src="/temp/IconCache/People/16x16/cube_blue.png">
                    <span>Caches By Database</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab lastTab" href="#" rel="ARRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <img class="tabIcon" src="/temp/IconCache/People/16x16/cube_blue.png">
                    <span>Access Result Caches</span>
                </span>
                <div class="tabClose"></div>
            </a>
            <a class="normalTab lastTab" href="#" rel="MiscRegion">
                <div class="tabOpen"></div>
                <span class="tabInfo">
                    <img class="tabIcon" src="/temp/IconCache/People/16x16/cube_blue.png">
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
			        <div class="GlobalControls">
						<div class="dataRow">
                            Total Cache Size: <span class="title"><asp:Literal ID="ltlSize" runat="server"></asp:Literal></span>
						</div>
                        <div class="dataRow">
                            Cache Entries: <span class="title"><asp:Literal ID="ltlEntries" runat="server"></asp:Literal></span>
						</div>
                        <div class="clear"></div>
			        </div>
                    <h2>Cache Search</h2>
                    <div class="GlobalControls">
                        <div class="fieldHighlight">
                            <asp:TextBox ID="txtGQuery" CssClass="txtQuery" runat="server"></asp:TextBox>				
						    <div class="clear"></div>
                            <div class="btnBox">
                                <div class="btn">
                                    <asp:Button ID="btnGQuery" CssClass="searchBtn" rel=".GlobalSearch" Text="Search All Cache" runat="server" OnClick="btnGQuery_Click" />        
                                </div>
                                <div class="btnSpacer">.</div>
                                <div class="btn">
                                    <asp:Button ID="btnGQueryClear" rel=".GlobalSearch" CssClass="BtnClear" Text="Clear Search Results" runat="server" OnClick="btnGQueryClear_Click" />
                                </div>
                                <div class="btnSpacer">.</div>
                                <div class="btn">
                                    <asp:button ID="c_clearAll" CssClass="clearAllBtn" runat="server" Text="Clear All Cache" OnClick="c_clearAll_Click"></asp:button>
						        </div>
                            </div>
                            <div class="clear"></div>    
                        </div>
                        <div class="rowSpacer"></div>
                        <div class="fieldHighlight">
                            <div class="ResultTitle">
						        <div class="btnBox">
                                    <div class="btn">
                                        <a href="#" class="toggle" onclick="CollapseNew(this, '.GlobalResults'); return false;">Collapse Results</a>
                                    </div>
                                    <div class="btnSpacer">.</div>
                                    <div class="btnMessage">
                                        <asp:Literal ID="ltlResults" runat="server"></asp:Literal>
                                    </div>
                                </div>
					        </div>
                            <div class="FormTitleRow">
								<div class="CacheName RowTitle">Cache Name</div>
								<div class="CacheKey RowTitle">Cache Key</div>
								<div class="clear"></div>
							</div>
					        <asp:Repeater ID="rptGQuery" runat="server">
						        <HeaderTemplate>
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
			<div class="overlay">Loading...</div>
			<div class="clear"></div>
		</div>
		<div class="Region SiteRegion">			
            <h2>Caches By Site 
				<a href="#" onclick="CollapseSections(this, '.CacheSiteForm .Section'); return false;">Toggle Form</a>
				<a href="#" onclick="CollapseSections(this, '.CacheList .Section'); return false;">Toggle Summary</a>
				<a href="#" onclick="CollapseSections(this, '.ProfileList .Section'); return false;">Toggle Cache Entries</a>
			</h2>
			<div class="CacheSiteForm">
				<div class="Section">
					<h3>Types 
						[ <a href="#" onclick="CheckAll(this, 'SiteTypeChecks');return false;">select all</a> ]
						<span>(choose at least one)</span>
					</h3>
					<div class="SiteTypeChecks">
						<asp:CheckBoxList ID="cblSiteTypes" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="Section">
					<h3>System Names 
						[ <a href="#" onclick="CheckAll(this, 'SysChecks');return false;">select all</a> ]
						<span>(choose at least one of either system or site name)</span>
					</h3>
					<div class="SysChecks">
						<asp:CheckBoxList ID="cblSysSiteNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
					<h3>Site Names
						[ <a href="#" onclick="CheckAll(this, 'SiteChecks');return false;">select all</a> ]
					</h3>					
					<div class="SiteChecks">
						<asp:CheckBoxList ID="cblSiteNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<div class="CacheList SiteCacheList">
				<asp:UpdatePanel ID="UpdatePanel2" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="btnFetch" rel=".SiteCacheList" runat="server" Text="Get Summary" OnClick="FetchSiteCacheList"></asp:button>
							<asp:button ID="btnClear" rel=".SiteCacheList" CssClass="BtnClear" runat="server" Text="Clear Summary Cache" OnClick="ClearSiteCacheList" ></asp:button>
						</div>
						<asp:Repeater ID="rptSiteCaches" runat="server">
							<HeaderTemplate>
								<div class="Section">
									<div class="Results">
										<div class="FormRow">
											<div class="Name RowTitle">Name</div>
											<div class="Count RowTitle">Cache Entries</div>
											<div class="Size RowTitle">Size</div>
											<div class="MaxSize RowTitle">MaxSize</div>
											<div class="clear"></div>
										</div>
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
								</div>
							</FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
			<div class="ProfileList SiteProfileList">
				<asp:UpdatePanel ID="UpdatePanel3" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button6" rel=".SiteProfileList" runat="server" Text="Get Cache Entries" OnClick="FetchSiteCacheProfile"></asp:button>
							<asp:button ID="Button8" rel=".SiteProfileList" CssClass="BtnClear" runat="server" Text="Clear Cache Entries" OnClick="ClearSiteCacheProfile"></asp:button>
						</div>
						<asp:Repeater ID="rptSiteCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
							<HeaderTemplate>
								<div class="Section">
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>	
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
		</div>
		<div class="Region DatabaseRegion">
			<h2>Caches By Database 
				<a href="#" onclick="CollapseSections(this, '.CacheSiteForm .Section'); return false;">Toggle Form</a>
				<a href="#" onclick="CollapseSections(this, '.CacheList .Section'); return false;">Toggle Summary</a>
				<a href="#" onclick="CollapseSections(this, '.ProfileList .Section'); return false;">Toggle Cache Entries</a>
			</h2>
			<div class="CacheSiteForm">
				<div class="Section">
					<h3>Types 
						[ <a href="#" onclick="CheckAll(this, 'DBTypeChecks');return false;">select all</a> ]
						<span>(choose at least one)</span>
					</h3>
					<div class="DBTypeChecks">
						<asp:CheckBoxList ID="cblDBTypes" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
				<div class="Section">
					<h3>Database Names 
						[ <a href="#" onclick="CheckAll(this, 'DBChecks');return false;">select all</a> ]
						<span>(choose at least one of either system or site name)</span>
					</h3>
					<div class="DBChecks">
						<asp:CheckBoxList ID="cblDBNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<div class="CacheList DBCacheList">
				<asp:UpdatePanel ID="UpdatePanel4" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button1" rel=".DBCacheList" runat="server" Text="Get Summary" OnClick="FetchDBCacheList"></asp:button>
							<asp:button ID="Button9" rel=".DBCacheList" runat="server" CssClass="BtnClear" Text="Clear Summary Cache" OnClick="ClearDBCacheList"></asp:button>
						</div>
						<asp:Repeater ID="rptDBCaches" runat="server">
							<HeaderTemplate>
								<div class="Section">
								<div class="Results">
								<div class="FormRow">
									<div class="Name RowTitle">Name</div>
									<div class="Count RowTitle">Cache Entries</div>
									<div class="Size RowTitle">Size</div>
									<div class="MaxSize RowTitle">MaxSize</div>
									<div class="clear"></div>
								</div>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
			<div class="ProfileList DBProfileList">
				<asp:UpdatePanel ID="UpdatePanel5" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button5" rel=".DBProfileList" runat="server" Text="Get Cache Entries" OnClick="FetchDBCacheProfile"></asp:button>
							<asp:button ID="Button10" rel=".DBProfileList" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearDBCacheProfile"></asp:button>
						</div>
						<asp:Repeater ID="rptDBCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
							<HeaderTemplate><div class="Section"><div class="Results"></HeaderTemplate>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
		</div>
		<div class="Region ARRegion">
			<h2>Access Result Caches 
				<a href="#" onclick="CollapseSections(this, '.CacheSiteForm .Section'); return false;">Toggle Form</a>
				<a href="#" onclick="CollapseSections(this, '.CacheList .Section'); return false;">Toggle Summary</a>
				<a href="#" onclick="CollapseSections(this, '.ProfileList .Section'); return false;">Toggle Cache Entries</a>
			</h2>
			<div class="CacheSiteForm">
				<div class="Section">
					<h3>Cache Names 
						[ <a href="#" onclick="CheckAll(this, 'MiscChecks');return false;">select all</a> ]
						<span>(choose at least one)</span>
					</h3>
					<div class="MiscChecks">
						<asp:CheckBoxList ID="cblAccessResult" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<div class="CacheList ARCacheList">
				<asp:UpdatePanel ID="UpdatePanel64" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button2" rel=".ARCacheList" runat="server" Text="Get Summary" OnClick="FetchARCacheList"></asp:button>
							<asp:button ID="Button11" rel=".ARCacheList" runat="server" CssClass="BtnClear" Text="Clear Summary" OnClick="ClearARCacheList"></asp:button>
						</div>
						<asp:Repeater ID="rptARCaches" runat="server">
							<HeaderTemplate>
								<div class="Section">
								<div class="Results">
								<div class="FormRow">
									<div class="Name RowTitle">Name</div>
									<div class="Count RowTitle">Cache Entries</div>
									<div class="Size RowTitle">Size</div>
									<div class="MaxSize RowTitle">MaxSize</div>
									<div class="clear"></div>
								</div>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
			<div class="ProfileList ARProfileList">
				<asp:UpdatePanel ID="UpdatePanel74" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button7" rel=".ARProfileList" runat="server" Text="Get Cache Entries" OnClick="FetchARCacheProfile"></asp:button>
							<asp:button ID="Button12" rel=".ARProfileList" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearARCacheProfile"></asp:button>
						</div>
						<asp:Repeater ID="rptARCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
							<HeaderTemplate><div class="Section"><div class="Results"></HeaderTemplate>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
		</div>
		<div class="Region MiscRegion">
			<h2>Miscellaneous Caches 
				<a href="#" onclick="CollapseSections(this, '.CacheSiteForm .Section'); return false;">Toggle Form</a>
				<a href="#" onclick="CollapseSections(this, '.CacheList .Section'); return false;">Toggle Summary</a>
				<a href="#" onclick="CollapseSections(this, '.ProfileList .Section'); return false;">Toggle Cache Entries</a>
			</h2>
			<div class="CacheSiteForm">
				<div class="Section">
					<h3>Cache Names 
						[ <a href="#" onclick="CheckAll(this, 'MiscChecks');return false;">select all</a> ]
						<span>(choose at least one)</span>
					</h3>
					<div class="MiscChecks">
						<asp:CheckBoxList ID="cblMiscNames" RepeatColumns="6" runat="server"></asp:CheckBoxList>
					</div>
				</div>
			</div>
			<div class="CacheList MiscCacheList">
				<asp:UpdatePanel ID="UpdatePanel6" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button3" rel=".MiscCacheList" runat="server" Text="Get Summary" OnClick="FetchMiscCacheList"></asp:button>
							<asp:button ID="Button14" rel=".MiscCacheList" runat="server" CssClass="BtnClear" Text="Clear Summary" OnClick="ClearMiscCacheList"></asp:button>
						</div>
						<asp:Repeater ID="rptMiscCaches" runat="server">
							<HeaderTemplate>
								<div class="Section">
								<div class="Results">
								<div class="FormRow">
									<div class="Name RowTitle">Name</div>
									<div class="Count RowTitle">Cache Entries</div>
									<div class="Size RowTitle">Size</div>
									<div class="MaxSize RowTitle">MaxSize</div>
									<div class="clear"></div>
								</div>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
			<div class="ProfileList MiscProfileList">
				<asp:UpdatePanel ID="UpdatePanel7" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:button ID="Button4" rel=".MiscProfileList" runat="server" Text="Get Cache Entries" OnClick="FetchMiscCacheProfile"></asp:button>
							<asp:button ID="Button13" rel=".MiscProfileList" runat="server" CssClass="BtnClear" Text="Clear Cache Entries" OnClick="ClearMiscCacheProfile"></asp:button>
						</div>
						<asp:Repeater ID="rptMiscCacheProfiles" OnItemDataBound="rptSCProfiles_DataBound" runat="server">
							<HeaderTemplate><div class="Section"><div class="Results"></HeaderTemplate>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
		</div>
    </form>
</body>
</html>