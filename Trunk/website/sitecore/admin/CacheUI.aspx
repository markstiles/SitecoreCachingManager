<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CacheUI.aspx.cs" Inherits="sitecore.admin.CacheUI" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
	<style>
		.clear { clear:both; }
		* { font-family:Arial; font-size:14px; color:#336699; }
		body { background-color:#aaaaaa; }
		h1, h2, h3, h4 { padding: 5px; margin:5px; color:#666; font-style:normal;}
		h1 { font-size:16px; }
		h2 { padding:10px 10px 5px; margin:0px; background-color:#cccccc; font-size:15px; }
			h2 a { font-weight:normal; display:inline-block; margin-left:20px; }
		h3 { font-size:14px; background-color:#ccc; font-weight:normal; }
			h3 span { font-weight:normal; }
		h4 { margin: 5px 0; color:#444; }
			h4 span { font-size:12px; font-weight:normal; }
		.title { font-weight:bold; color:#444; }
		.Region { margin:10px; border-right:4px solid #ccc; border-left:4px solid #ccc; border-bottom:10px solid #ccc; }
		.Section { background-color:#cccccc; }
		.ButtonSection { background-color:#cccccc; }
		.BtnClear { float:right; }
		.GlobalSearch, .SiteCacheList, .SiteProfileList, .DBCacheList, .DBProfileList, .ARCacheList, .ARProfileList, .MiscCacheList, .MiscProfileList { position:relative; }
		.GlobalControls { }
			.GlobalControls span { display:inline-block; margin-right:20px;}
			.GlobalControls .Section { display:block; padding:0 0 5px 10px; }
			.GlobalSearch .ButtonSection span { display:inline-block; margin-left:30px; }
		.CacheSiteForm, .CacheList, .ProfileList, .GlobalSearch { padding: 5px 0; margin:5px; background-color:#bbb; border: 1px solid #888888;}
			.CacheSiteForm .Section { display:none;}
			.CacheSiteForm a { margin:10px 0; font-size:12px; color:#000; }
			.CacheSiteForm .Section { padding:0px 5px; background:none; } 
		.CacheList {  }
			.ProfileList .Section, .CacheList .Section, .ButtonSection, .GlobalSearch .Section { padding:0px 5px 5px; background:none; display:block; }
			.Results { background-color: #AAAAAA; border: 1px solid #888888; margin-bottom: 5px; max-height: 350px; overflow: auto; padding: 0 5px;}
			.FormRow { clear:both; }
			.RowTitle { float:left; font-weight:bold; }
			.RowValue { float:left; }
			.CacheName { width:290px; }
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
	</style>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
    <script type="text/javascript">
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
		<div class="Region">
			<h2>Global Search 
				<a href="#" onclick="CollapseSections(this, '.GlobalSearch .Section'); return false;">Toggle Search Results</a>
			</h2>
			<div class="GlobalControls">
				<asp:UpdatePanel ID="UpdatePanel1" UpdateMode="Conditional" runat="server">
					<ContentTemplate>
						<div class="Section">
							Cache Entries: <span class="title"><asp:Literal ID="ltlEntries" runat="server"></asp:Literal></span>
							Total Size: <span class="title"><asp:Literal ID="ltlSize" runat="server"></asp:Literal></span>
							<asp:button ID="c_clearAll" runat="server" Text="Clear all" OnClick="c_clearAll_Click"></asp:button>
							<div class="clear"></div>
						</div>
						<div class="clear"></div>
					</ContentTemplate>
				</asp:UpdatePanel>
			</div>
			<div class="GlobalSearch">
				<asp:UpdatePanel ID="upGQuery" runat="server" UpdateMode="Conditional">
					<ContentTemplate>
						<div class="ButtonSection">
							<asp:TextBox ID="txtGQuery" runat="server"></asp:TextBox>				
							<asp:Button ID="btnGQuery" rel=".GlobalSearch" Text="Search All Cache" runat="server" OnClick="btnGQuery_Click" />
							<span>
								<asp:Literal ID="ltlResults" runat="server"></asp:Literal>
							</span>
							<asp:Button ID="btnGQueryClear" rel=".GlobalSearch" CssClass="BtnClear" Text="Clear Search Cache" runat="server" OnClick="btnGQueryClear_Click" />
						</div>
						<asp:Repeater ID="rptGQuery" runat="server">
							<HeaderTemplate>
								<div class="Section">
									<div class="Results">
										<div class="FormRow">
											<div class="CacheName RowTitle">Cache Name</div>
											<div class="CacheKey RowTitle">Cache Key</div>
											<div class="clear"></div>
										</div>
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
							<FooterTemplate></div></div></FooterTemplate>
						</asp:Repeater>
					</ContentTemplate>
				</asp:UpdatePanel>
				<div class="overlay">Loading...</div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="Region">
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
		<div class="Region">
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
		<div class="Region">
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
		<div class="Region">
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