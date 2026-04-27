----------------------------------------------------------
------ rathena
------ sader1992
------ https://rathena.org/board/profile/30766-sader1992/
----------------------------------------------------------
function add_url()
	local M = "<URL>[ Elves Ragnarok]<INFO>https://elvesro.com/</INFO></URL>"
	return M
end
function add_item_link(v)
	local M = "<URL>ItemID:" .. tostring(v) .. " <INFO>https://elvesro.com/item/view/?id=" .. tostring(v) .. "</INFO></URL>"
	-- FOR FluxCP
	--local M = "<URL>ItemID:[" .. tostring(v) .. "](Click Me!)<INFO>https://elvesro.com/item/view/?id=" .. tostring(v) .. "</INFO></URL>"
	return M
end
function main()
	IInfo = {"System.elves_pre","System.itemInfo_re"}
	-- Example!
	-- IInfo = {"System.import_iteminfo","System.kro_iteminfo5","System.kro_iteminfo4","System.kro_iteminfo3","System.kro_iteminfo2","System.kro_iteminfo1","System.kro_iteminfo"}
	ItemList = {}
	for key,ItemInfo in pairs(IInfo) do
		require(ItemInfo)
		for ItemID, DESCS in pairs(tbl) do
			if not ItemList[ItemID] then
				ItemList[ItemID] = true
				result, msg = AddItem(ItemID, DESCS.unidentifiedDisplayName, DESCS.unidentifiedResourceName, DESCS.identifiedDisplayName, DESCS.identifiedResourceName, DESCS.slotCount, DESCS.ClassNum)
				if not result == true then
					return false, msg
				end
				AddItemUnidentifiedDesc(ItemID, add_url())
				for k, v in pairs(DESCS.unidentifiedDescriptionName) do
					result, msg = AddItemUnidentifiedDesc(ItemID, v)
					if not result == true then
						return false, msg
					end
				end
				AddItemUnidentifiedDesc(ItemID, add_item_link(ItemID))
				AddItemIdentifiedDesc(ItemID, add_url())
				for k, v in pairs(DESCS.identifiedDescriptionName) do
					result, msg = AddItemIdentifiedDesc(ItemID, v)
					if not result == true then
						return false, msg
					end
				end
				AddItemIdentifiedDesc(ItemID, add_item_link(ItemID))
				if nil ~= DESCS.EffectID then
					result, msg = AddItemEffectInfo(ItemID, DESCS.EffectID)
				end
				if not result == true then
					return false, msg
				end
				if nil ~= DESCS.costume then
					result, msg = AddItemIsCostume(ItemID, DESCS.costume)
				end
				if not result == true then
					return false, msg
				end
			end
		end
	end
	return true, "good"
end