-- 在窗口显示时显示 OSD 提示

local osd_shown = false
local function show_loading_message()
    -- 延迟执行，确保 OSD 画布大小已更新
    if osd_shown then return end -- 如果已经显示过 OSD，则不再执行
    osd_shown = true

    mp.add_timeout(0.1, function()
        local osd_w = mp.get_property_number("osd-width", 1920) -- 获取 OSD 画布宽度
        local osd_h = mp.get_property_number("osd-height", 1080) -- 获取 OSD 画布高度

    -- 计算右上角位置（偏移 10 像素）
        local x = osd_w - 30   -- 右侧对齐
        local y = 30           -- 上侧对齐
        local font_size = math.floor(50 * (osd_h / 1080)) -- 自适应字体大小

    -- 生成 OSD 提示（右上角对齐）
        local ass = string.format("{\\an9}{\\pos(%d,%d)}{\\fs%d}播放emby需要等待10s+", x, y, font_size)
        mp.set_osd_ass(osd_w, osd_h, ass)

    -- 显示 OSD，并在 4.5 秒后清除
        mp.set_osd_ass(osd_w, osd_h, ass)
        mp.add_timeout(4.5, function() mp.set_osd_ass(0, 0, "") end)
    end)
end

mp.register_event("video-reconfig", show_loading_message)
