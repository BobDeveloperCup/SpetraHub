local a = (function()
    local a = game:GetService('TweenService')
    local b = game:GetService('UserInputService')
    local c = game:GetService('GuiService')
    local d = game:GetService('RunService')
    local e = game:GetService('HttpService')
    local f = game:GetService('Players')
    local g = game:GetService('TeleportService')
    local h = game:GetService('MarketplaceService')
    local i = game:GetService('Stats')
    local j = f.LocalPlayer
    local k = {}
    k.Flags = {}
    k.Windows = {}
    local function l(m, n)
        local o = {}
        if type(m) == 'string' then
            o.Name = m
        elseif type(m) == 'table' then
            for p, q in pairs(m) do
                o[p] = q
            end
        end
        for p, q in pairs(n or {}) do
            if o[q] == nil and o[p] ~= nil then
                o[q] = o[p]
            end
        end
        if o.Range then
            o.Min = o.Min or o.Range[1]
            o.Max = o.Max or o.Range[2]
        end
        return o
    end
    local function m(n, o, p, q, r)
        p._type = r
        p._frame = q
        p._listeners = p._listeners or {}
        local s = n and n.Window
        local t = o.Name or o.Text or o.Title
        p._searchName = type(t) == 'string' and t or ''
        p._searchKey = string.lower(p._searchName)
        if n and n._items then
            table.insert(n._items, p)
        end
        if o.Flag then
            k.Flags[o.Flag] = p
            if s then
                s:_flagCreated(o.Flag, p)
            end
        end
        p._userVisible = o.Visible ~= false
        function p:IsVisible()
            return p._userVisible
        end
        function p:_isShown()
            return p._userVisible and not (n and n._userVisible == false)
        end
        function p:SetVisible(u)
            u = u and true or false
            if u == p._userVisible or p._destroyed then
                return
            end
            p._userVisible = u
            if not u then
                if p._onHide then
                    p._onHide()
                end
                if p.Open and type(p.SetOpen) == 'function' then
                    p:SetOpen(false)
                end
            end
            if q then
                q.Visible = u
            end
            if s then
                s._controlsDirty = true
            end
        end
        if q and not p._userVisible then
            q.Visible = false
        end
        function p:SetTooltip(u)
            p._tooltip = u
            if q and s and not p._tooltipBound then
                p._tooltipBound = true
                s:_attachTooltip(p, q)
            end
        end
        function p:GetTooltip()
            return p._tooltip
        end
        if o.Tooltip ~= nil and o.Tooltip ~= false then
            p:SetTooltip(o.Tooltip)
        end
        function p:Destroy()
            if p._destroyed then
                return
            end
            p._destroyed = true
            if s and s._tipOwner == p then
                s:_hideTooltip()
            end
            for u, v in ipairs(p._listeners) do
                v()
            end
            p._listeners = {}
            if n and n._items then
                local u = table.find(n._items, p)
                if u then
                    table.remove(n._items, u)
                end
            end
            if o.Flag and k.Flags[o.Flag] == p then
                k.Flags[o.Flag] = nil
            end
            if s then
                s._controlsDirty = true
            end
            if q then
                q:Destroy()
            end
        end
        return p
    end
    k.Theme = {
        Background = Color3.fromRGB(15, 18, 26), Surface = Color3.fromRGB(18, 22, 31),
        Surface2 = Color3.fromRGB(22, 26, 37), Surface3 = Color3.fromRGB(37, 44, 60),
        Stroke = Color3.fromRGB(34, 40, 55), StrokeHover = Color3.fromRGB(70, 84, 112),
        Accent = Color3.fromRGB(128, 160, 246), AccentDark = Color3.fromRGB(14, 18, 30),
        Text = Color3.fromRGB(228, 232, 242), Muted = Color3.fromRGB(116, 126, 148),
        Warning = Color3.fromRGB(240, 176, 108), Success = Color3.fromRGB(150, 220, 170),
        Error = Color3.fromRGB(240, 120, 120)
    }
    local n = {
        'Accent', 'AccentDark', 'Background', 'Surface', 'Surface2', 'Surface3', 'Stroke',
        'StrokeHover', 'Text', 'Muted', 'Warning', 'Success', 'Error'
    }
    local function o(p, q, r)
        return Color3.fromRGB(p, q, r)
    end
    local function p(q, r, s, t, u, v, w, x, y, z)
        return {
            Background = o(table.unpack(q)), Surface = o(table.unpack(r)),
            Surface2 = o(table.unpack(s)), Surface3 = o(table.unpack(t)),
            Stroke = o(table.unpack(u)), StrokeHover = o(table.unpack(v)),
            Accent = o(table.unpack(w)), AccentDark = o(table.unpack(x)), Text = o(table.unpack(y)),
            Muted = o(table.unpack(z))
        }
    end
    k.ThemePresets = {
        Midnight = p(
            {15, 18, 26}, {18, 22, 31}, {22, 26, 37}, {37, 44, 60}, {34, 40, 55}, {70, 84, 112},
            {128, 160, 246}, {14, 18, 30}, {228, 232, 242}, {116, 126, 148}
        ),
        Ocean = p(
            {12, 20, 24}, {15, 24, 29}, {18, 29, 35}, {31, 48, 56}, {29, 44, 52}, {58, 92, 104},
            {110, 214, 222}, {10, 24, 28}, {226, 238, 240}, {108, 134, 140}
        ),
        Rose = p(
            {22, 15, 18}, {27, 18, 22}, {32, 21, 26}, {48, 34, 40}, {45, 30, 37}, {98, 64, 78},
            {246, 160, 186}, {30, 14, 20}, {240, 228, 232}, {138, 112, 120}
        ),
        Emerald = p(
            {13, 20, 17}, {16, 24, 20}, {20, 29, 24}, {33, 47, 40}, {30, 44, 37}, {62, 96, 78},
            {132, 226, 170}, {12, 26, 18}, {228, 240, 233}, {110, 136, 122}
        ),
        Amber = p(
            {22, 18, 13}, {27, 22, 16}, {32, 26, 19}, {49, 41, 31}, {46, 38, 28}, {100, 82, 58},
            {246, 196, 120}, {30, 22, 10}, {242, 236, 226}, {140, 126, 106}
        ),
        Mono = p(
            {16, 16, 17}, {20, 20, 21}, {25, 25, 26}, {40, 40, 42}, {38, 38, 40}, {84, 84, 88},
            {236, 236, 240}, {20, 20, 22}, {234, 234, 236}, {122, 122, 128}
        ),
        Nebula = p(
            {14, 12, 28}, {18, 15, 35}, {23, 19, 43}, {39, 32, 68}, {35, 29, 62}, {84, 68, 140},
            {199, 125, 255}, {22, 10, 40}, {236, 230, 252}, {124, 114, 160}
        ),
        Synthwave = p(
            {20, 12, 30}, {25, 15, 37}, {31, 18, 45}, {52, 30, 72}, {47, 27, 66}, {110, 58, 150},
            {255, 94, 198}, {38, 8, 30}, {250, 232, 246}, {150, 118, 160}
        ),
        Sakura = p(
            {24, 14, 20}, {29, 17, 24}, {35, 20, 29}, {54, 32, 45}, {50, 29, 41}, {112, 66, 92},
            {255, 158, 200}, {36, 12, 24}, {248, 232, 240}, {150, 112, 132}
        ),
        Velvet = p(
            {20, 10, 16}, {25, 12, 20}, {31, 15, 25}, {50, 25, 40}, {46, 23, 37}, {104, 52, 82},
            {222, 110, 170}, {30, 8, 20}, {244, 228, 238}, {142, 106, 126}
        ),
        Crimson = p(
            {18, 10, 12}, {23, 12, 15}, {28, 14, 18}, {46, 24, 29}, {42, 22, 27}, {104, 46, 56},
            {244, 74, 94}, {32, 8, 12}, {244, 230, 232}, {142, 106, 112}
        ),
        Sunset = p(
            {22, 13, 14}, {27, 16, 17}, {33, 19, 21}, {52, 31, 32}, {48, 28, 30}, {112, 62, 58},
            {255, 138, 92}, {34, 14, 8}, {248, 234, 228}, {150, 118, 110}
        ),
        Gold = p(
            {14, 13, 11}, {18, 17, 14}, {23, 21, 17}, {38, 35, 28}, {35, 32, 26}, {92, 80, 54},
            {232, 196, 122}, {30, 22, 8}, {240, 234, 222}, {136, 126, 106}
        ),
        Cyber = p(
            {13, 13, 15}, {17, 17, 19}, {21, 21, 24}, {36, 36, 40}, {33, 33, 37}, {86, 84, 70},
            {250, 226, 72}, {30, 26, 4}, {240, 240, 232}, {126, 124, 118}
        ),
        Toxic = p(
            {11, 14, 11}, {14, 18, 14}, {18, 23, 18}, {31, 39, 30}, {28, 36, 28}, {74, 98, 60},
            {184, 255, 74}, {18, 30, 6}, {232, 242, 228}, {116, 134, 110}
        ),
        Matcha = p(
            {16, 19, 14}, {20, 23, 17}, {24, 28, 21}, {40, 46, 34}, {37, 42, 31}, {84, 98, 70},
            {176, 214, 140}, {18, 26, 10}, {236, 240, 228}, {128, 136, 116}
        ),
        Aurora = p(
            {10, 20, 22}, {12, 25, 27}, {15, 30, 33}, {26, 50, 53}, {24, 45, 48}, {50, 104, 104},
            {94, 240, 180}, {6, 30, 22}, {224, 246, 240}, {102, 142, 134}
        ),
        Frost = p(
            {13, 17, 23}, {16, 21, 28}, {20, 26, 34}, {34, 43, 56}, {31, 40, 52}, {72, 92, 118},
            {164, 214, 255}, {12, 22, 34}, {230, 238, 246}, {114, 128, 146}
        ),
        Abyss = p(
            {7, 11, 22}, {9, 14, 28}, {12, 18, 35}, {22, 31, 58}, {20, 28, 52}, {44, 64, 120},
            {72, 148, 255}, {6, 14, 34}, {226, 234, 250}, {100, 116, 152}
        ),
        Halloween = p(
            {18, 12, 20}, {23, 15, 25}, {28, 18, 30}, {46, 30, 48}, {43, 28, 44}, {104, 62, 40},
            {255, 138, 36}, {36, 16, 4}, {246, 234, 224}, {146, 120, 128}
        ),
        Haunted = p(
            {14, 12, 20}, {18, 15, 26}, {22, 18, 32}, {38, 31, 54}, {35, 29, 50}, {70, 96, 64},
            {156, 255, 110}, {14, 30, 8}, {232, 240, 228}, {120, 116, 140}
        ),
        Christmas = p(
            {12, 20, 15}, {15, 25, 19}, {19, 30, 23}, {32, 50, 38}, {30, 46, 35}, {100, 54, 56},
            {236, 72, 80}, {34, 8, 10}, {240, 244, 236}, {120, 142, 128}
        ),
        Valentine = p(
            {24, 12, 17}, {30, 14, 21}, {36, 17, 25}, {58, 27, 40}, {54, 25, 37}, {130, 56, 84},
            {255, 92, 140}, {40, 8, 20}, {252, 232, 240}, {160, 112, 132}
        ),
        Lunar = p(
            {22, 10, 10}, {28, 12, 12}, {34, 15, 14}, {54, 24, 22}, {50, 22, 20}, {130, 92, 40},
            {246, 196, 84}, {38, 16, 6}, {250, 236, 222}, {160, 120, 108}
        ),
        Tropical = p(
            {10, 22, 24}, {12, 27, 30}, {15, 33, 36}, {26, 54, 58}, {24, 50, 54}, {44, 110, 110},
            {255, 170, 90}, {36, 18, 6}, {232, 246, 244}, {104, 144, 142}
        ),
        Dracula = p(
            {24, 25, 33}, {29, 30, 40}, {34, 36, 47}, {52, 55, 70}, {48, 50, 64}, {98, 114, 164},
            {189, 147, 249}, {26, 18, 44}, {246, 246, 238}, {126, 132, 168}
        ),
        Coffee = p(
            {20, 16, 13}, {25, 20, 16}, {30, 24, 19}, {48, 39, 31}, {45, 36, 29}, {104, 82, 62},
            {214, 170, 124}, {32, 22, 12}, {240, 230, 218}, {142, 124, 108}
        )
    }
    k.ThemeName = 'Midnight'
    k.Assets = {
        Shadow = 'rbxassetid://6014261993', Glow = 'rbxassetid://8992230677',
        Logo = 'rbxassetid://126046618277085'
    }
    local q = [[https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua]]
    local r = nil
    local function s()
        if r ~= nil then
            return r
        end
        local t, u = pcall(
            function()
                local t = game:HttpGet(q)
                return loadstring(t)()
            end
        )
        if t and type(u) == 'table' then
            r = u
        else
            r = false
            warn('[AirFlow] lucide icons unavailable: ' .. tostring(u))
        end
        return r
    end
    local t = {
        ValleySans = {
            Regular = [[https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Regular.ttf]],
            Medium = [[https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Medium.ttf]],
            SemiBold = [[https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-SemiBold.ttf]]
        }
    }
    local u = {
        Regular = {400, Enum.FontWeight.Regular}, Medium = {500, Enum.FontWeight.Medium},
        SemiBold = {600, Enum.FontWeight.SemiBold}, Bold = {700, Enum.FontWeight.Bold}
    }
    function k:LoadFont(v)
        v = l(v, {})
        if type(writefile) ~= 'function' or type(isfile) ~= 'function' or typeof(getcustomasset) ~= 'function' then
            warn([[[AirFlow] custom fonts need writefile, isfile and getcustomasset]])
            return false
        end
        local w = v.Name or 'CustomFont'
        local x = v.Weights or t[w]
        if type(x) ~= 'table' then
            warn('[AirFlow] no font weights for ' .. w)
            return false
        end
        local y = v.Folder or 'AirFlowFonts'
        pcall(
            function()
                if type(isfolder) == 'function' and type(makefolder) == 'function' and not isfolder(
                    y
                ) then
                    makefolder(y)
                end
            end
        )
        local z = {}
        for A, B in pairs(x) do
            local C = u[A]
            if C then
                local D = y .. '/' .. w .. '-' .. A .. '.ttf'
                local E = true
                if not isfile(D) then
                    E = pcall(
                        function()
                            writefile(D, game:HttpGet(B))
                        end
                    )
                end
                if E then
                    table.insert(
                        z, {name = A, weight = C[1], style = 'normal', assetId = getcustomasset(D)}
                    )
                else
                    warn('[AirFlow] could not download ' .. A .. ' weight of ' .. w)
                end
            end
        end
        if #z == 0 then
            return false
        end
        local A = y .. '/' .. w .. '.json'
        local B = pcall(
            function()
                writefile(A, e:JSONEncode({name = w, faces = z}))
            end
        )
        if not B then
            return false
        end
        local C = getcustomasset(A)
        local function D(E, F)
            local G = u[E]
            if G and x[E] then
                return Font.new(C, G[2])
            end
            return F
        end
        k.Fonts.Regular = D('Regular', k.Fonts.Regular)
        k.Fonts.Medium = D('Medium', D('Regular', k.Fonts.Medium))
        k.Fonts.Bold = D('SemiBold', D('Bold', k.Fonts.Bold))
        return true
    end
    function k:PreloadIcons()
        return s() ~= false
    end
    local function v(w)
        if type(w) == 'number' then
            return 'rbxassetid://' .. string.format('%.0f', w)
        end
        if type(w) == 'string' then
            if w:match('^%d+$') then
                return 'rbxassetid://' .. w
            end
            if w:find('^rbxassetid://') or w:find('^rbxasset://') or w:find('^rbxthumb://') or w:find(
                '^http'
            ) then
                return w
            end
        end
        return nil
    end
    local function w(x)
        if typeof(x) == 'table' then
            return v(x.Image) or x.Image, x.RectOffset, x.RectSize, true, x.Tint == true
        end
        local y = v(x)
        if y then
            return y, nil, nil, true, false
        end
        if type(x) ~= 'string' then
            return nil
        end
        local z = x:gsub('^lucide:', '')
        local A = s()
        if not A then
            return nil
        end
        local B = (A.Icons and A.Icons[z]) or A[z]
        if type(B) == 'table' then
            local C = B.Image
            if type(C) == 'number' then
                C = 'rbxassetid://' .. tostring(C)
            end
            local D = (A.Spritesheets and A.Spritesheets[tostring(C)]) or C
            return D, B.ImageRectPosition, B.ImageRectSize
        elseif type(B) == 'string' then
            return B
        end
        warn('[AirFlow] unknown lucide icon: ' .. z)
        return nil
    end
    local x = 'chevron-right'
    local y = 'rbxasset://fonts/families/BuilderSans.json'
    k.Fonts = {
        Regular = Font.new(y, Enum.FontWeight.Regular),
        Medium = Font.new(y, Enum.FontWeight.Medium), Bold = Font.new(y, Enum.FontWeight.SemiBold)
    }
    local z = k.Theme
    local A = k.Assets
    local B = [[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]
    local function C(D)
        local E = {}
        local F = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/]]
        for G = 1, #F do
            E[F:byte(G)] = G - 1
        end
        local G = {}
        for H = 1, #D, 4 do
            local I, J, K, L = D:byte(H, H + 3)
            local M = E[I] * 262144 + E[J] * 4096 + (E[K] or 0) * 64 + (E[L] or 0)
            local N, O, P = M // 65536, M // 256 % 256, M % 256
            if L ~= 61 then
                G[#G + 1] = string.char(N, O, P)
            elseif K ~= 61 then
                G[#G + 1] = string.char(N, O)
            else
                G[#G + 1] = string.char(N)
            end
        end
        return table.concat(G)
    end
    pcall(
        function()
            if type(writefile) ~= 'function' or typeof(getcustomasset) ~= 'function' then
                return
            end
            local D = 'AirFlowAssets'
            if type(isfolder) == 'function' and type(makefolder) == 'function' and not isfolder(D) then
                makefolder(D)
            end
            local E = D .. '/OuroFlowLogo.png'
            local F = C(B)
            local G = type(isfile) == 'function' and type(readfile) == 'function' and isfile(E) and readfile(
                E
            ) == F
            if not G then
                writefile(E, F)
            end
            local H = getcustomasset(E)
            if type(H) == 'string' and H ~= '' then
                A.Logo = H
            end
        end
    )
    local D = k.Fonts
    local E = b.TouchEnabled and not b.KeyboardEnabled
    k.Touch = E
    local F = 188
    local G = 62
    local H = 34
    local I = E and 54 or 48
    local J = E and 70 or 64
    local K = E and 40 or 34
    local L = E and 34 or 28
    local M = 64
    local N = 176
    local O = 440
    local P = {
        Card = {
            Compact = false, Height = I, DescHeight = J, Chip = L, Option = K, TextSize = 14,
            DescSize = 13, TitleHeight = 18, DescGap = 20, DescLine = 17, Slider = J
        },
        Row = {
            Compact = true, Height = E and 40 or 32, DescHeight = E and 54 or 46,
            Chip = E and 30 or 24, Option = E and 34 or 28, TextSize = 13, DescSize = 12,
            TitleHeight = 16, DescGap = 17, DescLine = 15, Slider = E and 54 or 46
        }
    }
    local Q = {}
    local R = {}
    local S = {}
    local T = {}
    local U = {}
    local V = 0
    local W = 4000
    local function X(Y, Z)
        for _ in pairs(Y) do
            if _.Parent == nil then
                if U[_] then
                    Y[_] = nil
                    U[_] = nil
                    if Z then
                        V -= 1
                    end
                else
                    U[_] = true
                end
            else
                U[_] = nil
            end
        end
    end
    local function Y()
        X(R, true)
        X(S, false)
        W = math.max(4000, V * 2)
    end
    local function Z(_)
        return math.floor(_.R * 255 + 0.5) .. ',' .. math.floor(_.G * 255 + 0.5) .. ',' .. math.floor(
            _.B * 255 + 0.5
        )
    end
    local function _()
        table.clear(T)
        for aa = #n, 1, -1 do
            local ab = n[aa]
            T[Z(k.Theme[ab])] = ab
        end
    end
    _()
    local function aa(ab, ac)
        for ad, ae in pairs(ac) do
            if typeof(ae) == 'Color3' then
                local af = T[Z(ae)]
                local ag = R[ab]
                if af then
                    if not ag then
                        ag = {}
                        R[ab] = ag
                        V += 1
                        if V >= W then
                            Y()
                        end
                    end
                    ag[ad] = af
                elseif ag then
                    ag[ad] = nil
                end
            end
        end
    end
    local ab = table.clone(k.Theme)
    local ac = nil
    local function ad(ae, af, ag)
        for ah, ai in pairs(af) do
            local aj = ag[ai]
            if aj then
                ae[ah] = aj
            end
        end
    end
    local function ae(af)
        for ag, ah in pairs(R) do
            pcall(ad, ag, ah, af)
        end
    end
    local function af(ag)
        if ac then
            ac:Disconnect()
            ac = nil
        end
        local ah, ai = {}, {}
        for aj, ak in ipairs(n) do
            local al = k.Theme[ak]
            local am = ab[ak] or al
            if am ~= al then
                ah[ak] = am
                ai[ak] = am
            end
        end
        local function aj()
            for ak, al in ipairs(n) do
                ai[al] = k.Theme[al]
                ab[al] = k.Theme[al]
            end
            ae(ai)
        end
        if ag <= 0 or next(ah) == nil then
            aj()
            return
        end
        local ak = 0
        ac = d.Heartbeat:Connect(
            function(al)
                ak += al
                if ak >= ag then
                    ac:Disconnect()
                    ac = nil
                    aj()
                    return
                end
                local am = 1 - (1 - ak / ag) ^ 5
                for an, ao in pairs(ah) do
                    local ap = ao:Lerp(k.Theme[an], am)
                    ai[an] = ap
                    ab[an] = ap
                end
                ae(ai)
            end
        )
    end
    local function ag(ah, ai)
        S[ah] = ai
        ai()
    end
    local function ah(ai, aj, ak, al, am, an)
        ak = ak or 0.2
        if not an then
            aa(ai, aj)
        end
        if ak <= 0 then
            for ao, ap in pairs(aj) do
                ai[ao] = ap
            end
            return nil
        end
        al = al or Enum.EasingStyle.Quart
        am = am or Enum.EasingDirection.Out
        local ao = ak .. al.Name .. am.Name
        local ap = Q[ao]
        if not ap then
            ap = TweenInfo.new(ak, al, am)
            Q[ao] = ap
        end
        local aq = a:Create(ai, ap, aj)
        aq:Play()
        return aq
    end
    local function ai(aj, ak, al)
        local am = Instance.new(aj)
        for an, ao in pairs(ak) do
            if an ~= 'Parent' then
                am[an] = ao
            end
        end
        aa(am, ak)
        if al then
            for an, ao in ipairs(al) do
                ao.Parent = am
            end
        end
        if ak.Parent then
            am.Parent = ak.Parent
        end
        return am
    end
    k.Roundness = 1
    k._cornerBases = {}
    local function aj(ak, al)
        al = al or UDim.new(0, 8)
        local am = ai(
            'UICorner',
            {
                CornerRadius = al.Scale == 0 and UDim.new(
                    0, math.floor(al.Offset * k.Roundness + 0.5)
                ) or al, Parent = ak
            }
        )
        if al.Scale == 0 then
            k._cornerBases[am] = al.Offset
        end
        return am
    end
    function k._fixedCorner(ak, al)
        return ai('UICorner', {CornerRadius = al, Parent = ak})
    end
    function k._radius(ak)
        return math.floor(ak * k.Roundness + 0.5)
    end
    local function ak(al, am, an, ao)
        return ai(
            'UIStroke',
            {
                Color = am or z.Stroke, Transparency = an or 0, Thickness = ao or 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = al
            }
        )
    end
    local function al(am, an, ao, ap, aq)
        return ai(
            'UIPadding',
            {
                PaddingLeft = UDim.new(0, an or 0), PaddingRight = UDim.new(0, ao or 0),
                PaddingTop = UDim.new(0, ap or 0), PaddingBottom = UDim.new(0, aq or 0), Parent = am
            }
        )
    end
    local function am(an)
        local ao = {
            BackgroundTransparency = 1, TextColor3 = z.Text, TextSize = 14, FontFace = D.Medium,
            TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
            TextTruncate = Enum.TextTruncate.AtEnd
        }
        for ap, aq in pairs(an) do
            ao[ap] = aq
        end
        return ai('TextLabel', ao)
    end
    local function an(ao, ap, aq, ar, as)
        local at = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = aq, Size = ap,
                BackgroundTransparency = 1, Image = A.Glow,
                ImageColor3 = Color3.fromRGB(226, 218, 230), ImageTransparency = 1, Visible = false,
                ZIndex = 0, Parent = ao
            }
        )
        local au = ai('UIGradient', {Rotation = as or 90, Parent = at})
        ag(
            au,
            function()
                au.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), z.Accent)
            end
        )
        return at
    end
    local function ao(ap)
        return ai(
            'Frame',
            {
                Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
                BorderSizePixel = 0, ZIndex = 0, Parent = ap
            }
        )
    end
    local ap = 1.35
    local function aq(ar, as, at)
        local au, av, aw, ax, ay = w(as)
        if not au then
            return
        end
        ar.Image = au
        ar.ImageRectOffset = av or Vector2.zero
        ar.ImageRectSize = aw or Vector2.zero
        if as == A.Logo then
            ay = true
        end
        local az = ax and not ay
        ar:SetAttribute('CustomIcon', az or nil)
        if az then
            ah(ar, {ImageColor3 = Color3.new(1, 1, 1)}, 0)
        end
        local aA = ax and not at and as ~= A.Logo and (typeof(as) == 'table' and tonumber(as.Scale) or ap) or 1
        local aB = ar:FindFirstChild('CustomIconScale')
        if aA ~= 1 then
            aB = aB or ai('UIScale', {Name = 'CustomIconScale', Parent = ar})
            aB.Scale = aA
        elseif aB then
            aB:Destroy()
        end
    end
    local function ar(as, at, au, av)
        if as:GetAttribute('CustomIcon') then
            ah(as, {ImageTransparency = au and 0 or 0.4}, av)
        else
            ah(as, {ImageColor3 = at}, av)
        end
    end
    local function as()
        local at
        pcall(
            function()
                if typeof(gethui) == 'function' then
                    at = gethui()
                end
            end
        )
        if typeof(at) == 'Instance' then
            return at
        end
        local au
        pcall(
            function()
                au = game:GetService('CoreGui')
                local av = Instance.new('Folder')
                av.Parent = au
                av:Destroy()
            end
        )
        if au then
            return au
        end
        return j:WaitForChild('PlayerGui')
    end
    local at, au = nil, Vector2.zero
    local function av()
        local aw = time()
        if at ~= aw then
            at = aw
            au = c:GetGuiInset()
        end
        return b:GetMouseLocation() - au
    end
    local function aw(ax)
        return ax.UserInputType == Enum.UserInputType.MouseButton1 or ax.UserInputType == Enum.UserInputType.Touch
    end
    local function ax()
        return b:GetLastInputType() == Enum.UserInputType.Touch
    end
    local function ay(az, aA)
        local aB
        az.InputBegan:Connect(
            function(aC)
                if aw(aC) then
                    local aD = aA()
                    aB = aD and aD.CanvasPosition
                end
            end
        )
        return function()
            local aC = aA()
            return not (aB and aC and (aC.CanvasPosition - aB).Magnitude > 4)
        end
    end
    local function az(aA, aB)
        local aC, aD = aB.AbsolutePosition, aB.AbsoluteSize
        return aA.X >= aC.X and aA.X <= aC.X + aD.X and aA.Y >= aC.Y and aA.Y <= aC.Y + aD.Y
    end
    local function aA(aB)
        return aB.UserInputType == Enum.UserInputType.MouseMovement or aB.UserInputType == Enum.UserInputType.Touch
    end
    local function aB(aC, aD, aE, aF)
        local aG = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = aF, Size = UDim2.fromOffset(16, 16),
                BackgroundTransparency = 1, Parent = aC
            }
        )
        local aH = ai(
            'ImageLabel',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ImageColor3 = aE,
                ScaleType = Enum.ScaleType.Fit, Parent = aG
            }
        )
        aq(aH, aD)
        return aG, aH
    end
    local function aC(aD, aE, aF)
        local aG = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(aE, 0.5), Position = UDim2.new(aE, aF, 0.5, 0),
                Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Parent = aD
            }
        )
        local aH = {}
        local aI = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ScaleType = Enum.ScaleType.Fit, Parent = aG
            }
        )
        aq(aI, 'chevron-down')
        if aI.Image ~= '' then
            function aH:Set(aJ)
                ah(
                    aI, {Rotation = aJ and 180 or 0, ImageColor3 = aJ and z.Accent or z.Muted}, 0.3,
                    Enum.EasingStyle.Quint
                )
            end
            return aH
        end
        aI:Destroy()
        local function aJ(aK, aL)
            return am(
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(18, 18), Text = '\u{203a}', TextSize = 22,
                    TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = z.Muted,
                    TextTransparency = aL, Rotation = aK, Parent = aG
                }
            )
        end
        local aK = aJ(90, 0)
        local aL = aJ(270, 1)
        function aH:Set(aM)
            ah(aK, {TextTransparency = aM and 1 or 0}, 0.2)
            ah(aL, {TextTransparency = aM and 0 or 1, TextColor3 = aM and z.Accent or z.Muted}, 0.2)
        end
        return aH
    end
    local aD = {}
    local function aE(aF)
        local aG = av()
        local aH = math.max(aF.AbsoluteSize.X, aF.AbsoluteSize.Y) * 2.2
        local aI = table.remove(aD)
        if aI and not pcall(
            function()
                aI.Parent = nil
            end
        ) then
            aI = nil
        end
        if not aI then
            aI = ai(
                'Frame',
                {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = z.Accent, BorderSizePixel = 0}
            )
            aj(aI, UDim.new(1, 0))
        end
        aI.Position = UDim2.fromOffset(aG.X - aF.AbsolutePosition.X, aG.Y - aF.AbsolutePosition.Y)
        aI.Size = UDim2.fromOffset(0, 0)
        aI.BackgroundColor3 = z.Accent
        aI.BackgroundTransparency = 0.82
        aI.ZIndex = aF.ZIndex + 1
        aI.Parent = aF
        ah(aI, {Size = UDim2.fromOffset(aH, aH), BackgroundTransparency = 1}, 0.55)
        task.delay(
            0.55,
            function()
                if aI.Parent ~= aF or not aF.Parent then
                    pcall(aI.Destroy, aI)
                    return
                end
                aI.Parent = nil
                if #aD < 4 then
                    table.insert(aD, aI)
                else
                    aI:Destroy()
                end
            end
        )
    end
    local function aF(aG)
        if not aG or aG:GetAttribute('Hidden') then
            return
        end
        ah(aG, {Color = z.Accent, Transparency = 0.2}, 0.08)
        task.delay(
            0.12,
            function()
                ah(aG, {Color = z.Stroke, Transparency = 0}, 0.35)
            end
        )
    end
    local function aG(aH, aI)
        aH.MouseEnter:Connect(
            function()
                ah(aI, {Color = z.StrokeHover}, 0.12)
            end
        )
        aH.MouseLeave:Connect(
            function()
                ah(aI, {Color = z.Stroke}, 0.25)
            end
        )
    end
    local aH = {
        [Enum.KeyCode.LeftControl] = 'LCtrl', [Enum.KeyCode.RightControl] = 'RCtrl',
        [Enum.KeyCode.LeftShift] = 'LShift', [Enum.KeyCode.RightShift] = 'RShift',
        [Enum.KeyCode.LeftAlt] = 'LAlt', [Enum.KeyCode.RightAlt] = 'RAlt',
        [Enum.KeyCode.Return] = 'Enter', [Enum.KeyCode.Escape] = 'Esc',
        [Enum.KeyCode.Backspace] = 'Backspace'
    }
    local function aI(aJ)
        if aJ == nil then
            return 'None'
        end
        return aH[aJ] or aJ.Name
    end
    local function aJ(aK, ...)
        if type(aK) ~= 'function' then
            return
        end
        local aL, aM = pcall(aK, ...)
        if not aL then
            warn('[AirFlow] callback error: ' .. tostring(aM))
        end
    end
    local function aK(aL)
        local aM = nil
        task.spawn(
            function()
                aM = table.pack(pcall(aL))
            end
        )
        while aM == nil do
            task.wait()
        end
        return table.unpack(aM, 1, aM.n)
    end
    local function aL(aM, aN, aO)
        local aP = 0
        local aQ = tostring(aO)
        local aR = aQ:find('%.')
        if aR then
            aP = #aQ - aR
        end
        local aS = '%.' .. aP .. 'f'
        return {
            snap = function(aT)
                aT = math.floor(aT / aO + 0.5) * aO
                return math.clamp(aT, aM, aN)
            end,
            format = function(aT)
                return string.format(aS, aT)
            end
        }
    end
    local function aM(aN)
        return aN._metrics or P.Card
    end
    local function aN(aO, aP)
        local aQ = aO.AbsoluteSize.X / aP.Scale.Scale
        return math.clamp(math.floor(aQ * 0.48), 90, 220)
    end
    local function aO(aP, aQ, aR, aS)
        local aT = aM(aP).Compact
        local aU = {
            Size = UDim2.new(1, 0, 0, aR), BackgroundColor3 = z.Surface2,
            BackgroundTransparency = aT and 1 or 0, BorderSizePixel = 0,
            LayoutOrder = aP:_nextOrder(), Parent = aP.List
        }
        if aQ == 'TextButton' then
            aU.AutoButtonColor = false
            aU.Text = ''
        end
        local aV = ai(aQ, aU)
        aV:SetAttribute('NoDrag', true)
        aj(aV)
        local aW = ak(aV, z.Stroke, aT and 1 or 0)
        if aT then
            aW:SetAttribute('Hidden', true)
        end
        return aV, aW
    end
    local function aP(aQ, aR, aS, aT, aU)
        aU = aU or P.Card
        local aV, aW
        if aS then
            local aX = math.floor((aU.DescHeight - (aU.DescGap + aU.DescLine)) / 2)
            aV = am(
                {
                    Position = UDim2.fromOffset(14, aX),
                    Size = UDim2.new(1, -(14 + aT), 0, aU.TitleHeight), Text = aR,
                    TextSize = aU.TextSize, Parent = aQ
                }
            )
            aW = am(
                {
                    Position = UDim2.fromOffset(14, aX + aU.DescGap),
                    Size = UDim2.new(1, -(14 + aT), 0, aU.DescLine), Text = aS,
                    TextSize = aU.DescSize, FontFace = D.Regular, TextColor3 = z.Muted, Parent = aQ
                }
            )
        else
            aV = am(
                {
                    Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -(14 + aT), 1, 0),
                    Text = aR, TextSize = aU.TextSize, Parent = aQ
                }
            )
        end
        return aV, aW
    end
    local function aQ(aR, aS, aT, aU, aV, aW)
        aS = l(aS, aT)
        local aX = aM(aR)
        local aY = aS.Desc and aX.DescHeight or aX.Height
        local aZ, a_ = aO(aR, aU or 'Frame', aY, aS)
        aG(aZ, a_)
        local a0, a1
        if aV then
            a0, a1 = aP(aZ, aS.Name or aW, aS.Desc, aV, aX)
        end
        return aS, aZ, a_, aY, a0, a1
    end
    local function aR(aS, aT, aU)
        if aS then
            aS.Size = UDim2.new(1, -(14 + aU), aS.Size.Y.Scale, aS.Size.Y.Offset)
        end
        if aT then
            aT.Size = UDim2.new(1, -(14 + aU), 0, aT.Size.Y.Offset)
        end
    end
    local aS = {}
    aS.__index = aS
    function aS:_nextOrder()
        self._order = self._order + 1
        return self._order
    end
    function aS:Section(aT)
        local aU = not (type(aT) == 'table' and aT.Visible == false)
        if type(aT) == 'table' then
            aT = aT.Name or aT.Title or ''
        end
        local aV = aM(self).Compact and 14 or 2
        local aW = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1,
                LayoutOrder = self:_nextOrder(), Parent = self.List
            }
        )
        local aX = am(
            {
                Position = UDim2.fromOffset(aV, 8), Size = UDim2.new(0, 0, 0, 16),
                AutomaticSize = Enum.AutomaticSize.X, Text = string.upper(aT), TextSize = 12,
                TextColor3 = z.Muted, TextTruncate = Enum.TextTruncate.None, Parent = aW
            }
        )
        local aY = aV == 2 and 0 or aV
        local aZ = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -aY, 0, 16),
                Size = UDim2.new(1, -12, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                Parent = aW
            }
        )
        local function a_()
            aZ.Size = UDim2.new(
                1, -(aX.AbsoluteSize.X / self.Window.Scale.Scale + aV + 12 + aY), 0, 1
            )
        end
        aX:GetPropertyChangedSignal('AbsoluteSize'):Connect(a_)
        task.defer(a_)
        return m(
            self, {Visible = aU},
            {
                Set = function(a0, a1)
                    aX.Text = string.upper(a1)
                end
            }, aW, 'Section'
        )
    end
    function aS:Divider(aT)
        local aU = type(aT) == 'table' and (aT.Text or aT.Name) or type(aT) == 'string' and aT or nil
        if aU then
            local aV = aM(self).Compact and 14 or 2
            local aW = ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1,
                    LayoutOrder = self:_nextOrder(), Parent = self.List
                }
            )
            local aX = am(
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 14), AutomaticSize = Enum.AutomaticSize.X, Text = aU,
                    TextSize = 11, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextTruncate = Enum.TextTruncate.None, Parent = aW
                }
            )
            al(aX, 8, 8)
            local aY = {}
            for aZ, a_ in ipairs({0, 1}) do
                aY[aZ] = ai(
                    'Frame',
                    {
                        AnchorPoint = Vector2.new(a_, 0.5),
                        Position = UDim2.new(a_, a_ == 0 and aV or -aV, 0.5, 0),
                        Size = UDim2.new(0.5, -aV, 0, 1), BackgroundColor3 = z.Stroke,
                        BorderSizePixel = 0, Parent = aW
                    }
                )
            end
            local function aZ()
                local a_ = aX.AbsoluteSize.X / self.Window.Scale.Scale / 2
                for a0, a1 in ipairs(aY) do
                    a1.Size = UDim2.new(0.5, -(aV + a_), 0, 1)
                end
            end
            aX:GetPropertyChangedSignal('AbsoluteSize'):Connect(aZ)
            task.defer(aZ)
            return m(
                self, {Visible = not (type(aT) == 'table' and aT.Visible == false)},
                {
                    Set = function(a_, a0)
                        aX.Text = tostring(a0)
                    end
                }, aW, 'Divider'
            )
        end
        local aV = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                LayoutOrder = self:_nextOrder(), Parent = self.List
            }
        )
        if aM(self).Compact then
            aV.BackgroundTransparency = 1
            aV.Size = UDim2.new(1, 0, 0, 9)
            ai(
                'Frame',
                {
                    Position = UDim2.fromOffset(14, 4), Size = UDim2.new(1, -28, 0, 1),
                    BackgroundColor3 = z.Stroke, BorderSizePixel = 0, Parent = aV
                }
            )
        end
        return m(
            self, {Visible = not (type(aT) == 'table' and aT.Visible == false)}, {}, aV, 'Divider'
        )
    end
    function aS:Label(aT)
        aT = l(aT, {Name = 'Text', Title = 'Text'})
        local aU = am(
            {
                Size = UDim2.new(1, 0, 0, 18), Text = k._rich(aT.Text or ''), TextSize = 13,
                FontFace = D.Regular, TextColor3 = k._color(aT.Color) or z.Muted, RichText = true,
                LayoutOrder = self:_nextOrder(), Parent = self.List
            }
        )
        if aM(self).Compact then
            aU.TextSize = 12
            al(aU, 14, 14)
        else
            al(aU, 2)
        end
        local aV = {
            Set = function(aV, aW)
                aU.Text = k._rich(aW)
            end,
            Get = function()
                return aU.Text
            end,
            SetColor = function(aV, aW)
                ah(aU, {TextColor3 = k._color(aW) or z.Muted}, 0.25)
            end
        }
        if type(aT.Update) == 'function' then
            local aW = math.max(tonumber(aT.UpdateRate) or 1, 0.05)
            local aX = true
            aV._listeners = aV._listeners or {}
            table.insert(
                aV._listeners,
                function()
                    aX = false
                end
            )
            task.spawn(
                function()
                    while aX and aU.Parent do
                        local aY, aZ = aK(aT.Update)
                        if aY and aZ ~= nil then
                            aU.Text = k._rich(aZ)
                        elseif not aY then
                            warn('[AirFlow] label update error: ' .. tostring(aZ))
                        end
                        task.wait(aW)
                    end
                end
            )
            function aV:SetUpdateRate(aY)
                aW = math.max(tonumber(aY) or aW, 0.05)
            end
        end
        return m(self, aT, aV, aU, 'Label')
    end
    function aS:Paragraph(aT)
        aT = l(aT, {Title = 'Name'})
        local aU = aO(self, 'Frame', 0, aT)
        aU.AutomaticSize = Enum.AutomaticSize.Y
        if aM(self).Compact then
            al(aU, 14, 14, 6, 8)
        else
            al(aU, 14, 14, 11, 12)
        end
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = aU}
        )
        am({Size = UDim2.new(1, 0, 0, 14), Text = aT.Name or '', LayoutOrder = 1, Parent = aU})
        local aV = am(
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                Text = k._rich(aT.Content or ''), TextSize = 13, FontFace = D.Regular,
                TextColor3 = z.Muted, TextWrapped = true, TextTruncate = Enum.TextTruncate.None,
                TextYAlignment = Enum.TextYAlignment.Top, RichText = true, LayoutOrder = 2,
                Parent = aU
            }
        )
        return m(
            self, aT,
            {
                Set = function(aW, aX)
                    aV.Text = k._rich(aX)
                end
            }, aU, 'Paragraph'
        )
    end
    local function aT(aU, aV)
        local aW = aV.Style == 'Primary'
        local aX = E and 34 or 28
        local aY = aX + 6 + (aV.Desc and 16 or 0)
        local aZ = aO(aU, 'TextButton', aY, aV)
        local a_ = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(14, 3), Size = UDim2.new(1, -28, 0, aX),
                BackgroundColor3 = aW and z.Accent or z.Surface3,
                BackgroundTransparency = aW and 0.12 or 0.45, BorderSizePixel = 0,
                ClipsDescendants = true, Parent = aZ
            }
        )
        aj(a_, UDim.new(0, 6))
        local a0 = ak(a_, aW and z.Accent or z.Stroke, aW and 0.4 or 0)
        local a1 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Parent = a_
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = a1
            }
        )
        local a2 = aW and z.AccentDark or z.Text
        if aV.Icon then
            local a3 = ai(
                'ImageLabel',
                {
                    Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                    ImageColor3 = aW and z.AccentDark or z.Accent, ScaleType = Enum.ScaleType.Fit,
                    LayoutOrder = 1, Parent = a1
                }
            )
            aq(a3, aV.Icon)
        end
        local a3 = am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                Text = aV.Name or 'Button', TextSize = 13, TextColor3 = a2,
                TextTruncate = Enum.TextTruncate.None, LayoutOrder = 2, Parent = a1
            }
        )
        if aV.Desc then
            am(
                {
                    Position = UDim2.fromOffset(14, aX + 6), Size = UDim2.new(1, -28, 0, 14),
                    Text = aV.Desc, TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted,
                    Parent = aZ
                }
            )
        end
        local a4 = aW and 0.12 or 0.45
        aZ.MouseEnter:Connect(
            function()
                ah(a_, {BackgroundTransparency = aW and 0 or 0.2}, 0.12)
                ah(a0, aW and {Transparency = 0} or {Color = z.StrokeHover}, 0.12)
            end
        )
        aZ.MouseLeave:Connect(
            function()
                ah(a_, {BackgroundTransparency = a4}, 0.25)
                ah(a0, aW and {Transparency = 0.4} or {Color = z.Stroke}, 0.25)
            end
        )
        aZ.MouseButton1Click:Connect(
            function()
                aE(a_)
                aJ(aV.Callback)
            end
        )
        return m(
            aU, aV,
            {
                SetText = function(a5, a6)
                    a3.Text = a6
                end
            }, aZ, 'Button'
        )
    end
    function aS:Button(aU)
        aU = l(aU, {Title = 'Name', Description = 'Desc'})
        if aM(self).Compact then
            return aT(self, aU)
        end
        local aV = aU.Style == 'Primary'
        local aW = aU.Desc and J or I
        local aX, aY = aO(self, 'TextButton', aW, aU)
        aX.ClipsDescendants = true
        if aV then
            ah(aX, {BackgroundColor3 = z.Accent, BackgroundTransparency = 0.12}, 0)
            ah(aY, {Color = z.Accent}, 0)
            aY.Transparency = 0.4
            aX.MouseEnter:Connect(
                function()
                    ah(aX, {BackgroundTransparency = 0}, 0.12)
                    ah(aY, {Transparency = 0}, 0.12)
                end
            )
            aX.MouseLeave:Connect(
                function()
                    ah(aX, {BackgroundTransparency = 0.12}, 0.25)
                    ah(aY, {Transparency = 0.4}, 0.25)
                end
            )
        else
            aG(aX, aY)
        end
        local aZ = aV and z.AccentDark or z.Text
        local a_ = 0
        if aU.Icon then
            aB(aX, aU.Icon, aV and z.AccentDark or z.Accent, UDim2.new(0, 14, 0.5, 0))
            a_ = 26
        end
        local a0 = aP(aX, aU.Name or 'Button', aU.Desc, 30)
        if a_ > 0 then
            for a1, a2 in ipairs(aX:GetChildren()) do
                if a2:IsA('TextLabel') then
                    a2.Position = a2.Position + UDim2.fromOffset(a_, 0)
                    a2.Size = a2.Size - UDim2.fromOffset(a_, 0)
                end
            end
        end
        if aV then
            for a1, a2 in ipairs(aX:GetChildren()) do
                if a2:IsA('TextLabel') then
                    ah(a2, {TextColor3 = aZ}, 0)
                end
            end
        end
        aB(aX, x, aV and z.AccentDark or z.Muted, UDim2.new(1, -30, 0.5, 0))
        aX.MouseButton1Click:Connect(
            function()
                aE(aX)
                aJ(aU.Callback)
            end
        )
        return m(
            self, aU,
            {
                SetText = function(a1, a2)
                    a0.Text = a2
                end
            }, aX, 'Button'
        )
    end
    function aS:Toggle(aU)
        local aV, aW
        aU, aV, aW = aQ(
            self, aU,
            {Title = 'Name', Description = 'Desc', CurrentValue = 'Default', Value = 'Default'},
            'TextButton', 56, 'Toggle'
        )
        local aX = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
                Size = E and UDim2.fromOffset(44, 24) or UDim2.fromOffset(36, 20),
                BackgroundColor3 = z.Surface3, BorderSizePixel = 0, Parent = aV
            }
        )
        aj(aX, UDim.new(1, 0))
        ak(aX, z.Stroke)
        local aY = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0),
                Size = E and UDim2.fromOffset(18, 18) or UDim2.fromOffset(14, 14),
                BackgroundColor3 = z.Muted, BorderSizePixel = 0, Parent = aX
            }
        )
        aj(aY, UDim.new(1, 0))
        local aZ = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.new(1, 24, 1, 24), BackgroundTransparency = 1, Image = A.Glow,
                ImageColor3 = z.Accent, ImageTransparency = 1, ZIndex = 0, Parent = aX
            }
        )
        local a_ = {Value = aU.Default == true}
        local function a0(a1)
            local a2 = a_.Value
            local a3 = a1 and 0.25 or 0
            ah(aX, {BackgroundColor3 = a2 and z.Accent or z.Surface3}, a3)
            ah(aZ, {ImageTransparency = a2 and 0.75 or 1}, a3)
            local a4 = E and 18 or 14
            ah(
                aY,
                {
                    Position = a2 and UDim2.new(0, (E and 44 or 36) - 3 - a4, 0.5, 0) or UDim2.new(
                        0, 3, 0.5, 0
                    ), BackgroundColor3 = a2 and z.AccentDark or z.Muted
                }, a3, Enum.EasingStyle.Back
            )
            if a1 then
                ah(aY, {Size = UDim2.fromOffset(a4 + 4, a4 - 2)}, 0.08)
                task.delay(
                    0.08,
                    function()
                        ah(aY, {Size = UDim2.fromOffset(a4, a4)}, 0.2, Enum.EasingStyle.Back)
                    end
                )
            end
        end
        local a1 = false
        function a_:Set(a2, a3)
            a2 = a2 == true
            if a2 == a_.Value then
                return
            end
            a_.Value = a2
            a0(true)
            if not a1 then
                aF(aW)
            end
            if not a3 then
                aJ(aU.Callback, a2)
            end
        end
        function a_:Get()
            return a_.Value
        end
        a0(false)
        aV.MouseButton1Click:Connect(
            function()
                a1 = true
                a_:Set(not a_.Value)
                a1 = false
            end
        )
        local a2 = m(self, aU, a_, aV, 'Toggle')
        if a_.Value then
            aJ(aU.Callback, true)
        end
        return a2
    end
    function aS:Slider(aU)
        aU = l(
            aU,
            {
                Title = 'Name', Description = 'Desc', CurrentValue = 'Default', Value = 'Default',
                Increment = 'Step'
            }
        )
        local aV = aU.Min or 0
        local aW = aU.Max or 100
        local aX = aU.Step or 1
        local aY = aU.Suffix or ''
        local aZ = aL(aV, aW, aX)
        local a_ = aM(self)
        local a0 = a_.Compact
        local a1 = a_.Slider
        local a2, a3 = aO(self, 'Frame', a1, aU)
        aG(a2, a3)
        am(
            {
                Position = UDim2.fromOffset(14, a0 and 5 or 12), Size = UDim2.new(1, -120, 0, 18),
                Text = aU.Name or 'Slider', TextSize = a_.TextSize, Parent = a2
            }
        )
        local a4 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, a0 and -14 or -10, 0, a0 and 2 or 9),
                Size = UDim2.fromOffset(40, 24), BackgroundColor3 = z.Surface, BorderSizePixel = 0,
                ClipsDescendants = true, Parent = a2
            }
        )
        aj(a4, UDim.new(0, 6))
        local a5 = ak(a4)
        local a6 = am(
            {
                Size = UDim2.new(1, 0, 1, 0), TextSize = 13, TextColor3 = z.Accent,
                TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None,
                Parent = a4
            }
        )
        local a7 = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(9, 0), Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Text = '',
                TextColor3 = z.Text, TextSize = 13, FontFace = D.Medium,
                TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
                Visible = false, Parent = a4
            }
        )
        ai('UISizeConstraint', {MinSize = Vector2.new(14, 0), Parent = a7})
        local a8 = am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = aY,
                TextSize = 13, TextColor3 = z.Accent, TextTruncate = Enum.TextTruncate.None,
                Visible = false, Parent = a4
            }
        )
        local a9 = ai(
            'TextButton',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, ZIndex = 2, Parent = a4
            }
        )
        local ba = false
        local function bb(bc)
            local bd
            if ba then
                bd = 9 + a7.AbsoluteSize.X / (self.Window.Scale.Scale) + a8.TextBounds.X + 9
                a8.Position = UDim2.fromOffset(9 + a7.AbsoluteSize.X / (self.Window.Scale.Scale), 0)
            else
                bd = a6.TextBounds.X + 18
            end
            bd = math.max(bd, 36)
            if bc then
                a4.Size = UDim2.fromOffset(bd, 24)
            else
                ah(a4, {Size = UDim2.fromOffset(bd, 24)}, 0.2)
            end
        end
        a6:GetPropertyChangedSignal('TextBounds'):Connect(
            function()
                if not ba then
                    bb(false)
                end
            end
        )
        a7:GetPropertyChangedSignal('AbsoluteSize'):Connect(
            function()
                if ba then
                    bb(false)
                end
            end
        )
        local bc = ai(
            'Frame',
            {
                Position = UDim2.new(0, 14, 0, a1 - (a0 and 13 or 18)),
                Size = UDim2.new(1, -28, 0, 5), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Parent = a2
            }
        )
        aj(bc, UDim.new(1, 0))
        local bd = ai(
            'Frame',
            {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = z.Accent, BorderSizePixel = 0, Parent = bc}
        )
        aj(bd, UDim.new(1, 0))
        local be = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1, Image = A.Glow,
                ImageColor3 = z.Accent, ImageTransparency = 0.85, ZIndex = 2, Parent = bc
            }
        )
        local bf = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(12, 12), BackgroundColor3 = z.Accent, BorderSizePixel = 0,
                ZIndex = 3, Parent = bc
            }
        )
        aj(bf, UDim.new(1, 0))
        local bg = ai(
            'TextButton',
            {
                Position = UDim2.new(0, 8, 0, a1 - (a0 and 13 or 18) - (E and 19 or 13)),
                Size = UDim2.new(1, -16, 0, E and 40 or 28), BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, ZIndex = 4, Parent = a2
            }
        )
        local bh = {Value = math.clamp(aU.Default or aV, aV, aW)}
        local bi = false
        a9.MouseEnter:Connect(
            function()
                ah(a5, {Color = z.StrokeHover}, 0.12)
            end
        )
        a9.MouseLeave:Connect(
            function()
                if not a7:IsFocused() then
                    ah(a5, {Color = z.Stroke}, 0.2)
                end
            end
        )
        a9.MouseButton1Click:Connect(
            function()
                ba = true
                a7.Text = aZ.format(bh.Value)
                a6.Visible = false
                a7.Visible = true
                a8.Visible = aY ~= ''
                a9.Visible = false
                ah(a5, {Color = z.StrokeHover}, 0.12)
                a7:CaptureFocus()
                task.defer(bb, false)
            end
        )
        a7.FocusLost:Connect(
            function()
                local bj = tonumber(a7.Text)
                ba = false
                a7.Visible = false
                a8.Visible = false
                a6.Visible = true
                a9.Visible = true
                ah(a5, {Color = z.Stroke}, 0.2)
                if bj then
                    bh:Set(bj)
                end
                bb(false)
            end
        )
        bg.MouseEnter:Connect(
            function()
                if not bi then
                    ah(be, {ImageTransparency = 0.78, Size = UDim2.fromOffset(34, 34)}, 0.15)
                end
            end
        )
        bg.MouseLeave:Connect(
            function()
                if not bi then
                    ah(be, {ImageTransparency = 0.85, Size = UDim2.fromOffset(28, 28)}, 0.2)
                end
            end
        )
        local bj = aZ.snap
        local function bk()
            return (aW - aV) == 0 and 0 or (bh.Value - aV) / (aW - aV)
        end
        local function bl(bm, bn, bo)
            bo = bo or Enum.EasingStyle.Linear
            ah(bd, {Size = UDim2.new(bm, 0, 1, 0)}, bn, bo)
            ah(bf, {Position = UDim2.new(bm, 0, 0.5, 0)}, bn, bo)
            ah(be, {Position = UDim2.new(bm, 0, 0.5, 0)}, bn, bo)
        end
        local function bm(bn, bo)
            bl(bk(), bn, bo)
            a6.Text = aZ.format(bh.Value) .. aY
        end
        local function bn(bo)
            local bp = bk()
            local bq = math.max(bc.AbsoluteSize.X, 1)
            local br = (bp >= bo and 1 or -1) * (5 / bq)
            bl(math.clamp(bp + br, 0, 1), 0.22, Enum.EasingStyle.Quint)
            task.delay(
                0.22,
                function()
                    if not bi then
                        bl(bk(), 0.18, Enum.EasingStyle.Quint)
                    end
                end
            )
            a6.Text = aZ.format(bh.Value) .. aY
        end
        local function bo()
            ah(bf, {Size = UDim2.fromOffset(14, 12)}, 0.08)
            ah(be, {Size = UDim2.fromOffset(32, 32), ImageTransparency = 0.78}, 0.12)
            task.delay(
                0.1,
                function()
                    ah(bf, {Size = UDim2.fromOffset(12, 12)}, 0.25, Enum.EasingStyle.Quint)
                    ah(be, {Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85}, 0.25)
                end
            )
        end
        function bh:Set(bp, bq)
            bp = bj(tonumber(bp) or aV)
            if bp == bh.Value then
                return
            end
            local br = bk()
            bh.Value = bp
            if bi then
                bm(0.05)
            else
                bn(br)
                bo()
                aF(a3)
            end
            if not bq then
                aJ(aU.Callback, bp)
            end
        end
        function bh:Get()
            return bh.Value
        end
        local function bp(bq)
            local br = math.clamp((bq - bc.AbsolutePosition.X) / bc.AbsoluteSize.X, 0, 1)
            bh:Set(aV + (aW - aV) * br)
        end
        bg.InputBegan:Connect(
            function(bq)
                if aw(bq) then
                    bi = true
                    bh.Dragging = true
                    ah(bf, {Size = UDim2.fromOffset(16, 16)}, 0.15, Enum.EasingStyle.Back)
                    ah(be, {Size = UDim2.fromOffset(44, 44), ImageTransparency = 0.7}, 0.15)
                    bp(av().X)
                end
            end
        )
        self.Window:_listen(
            'Changed',
            function(bq)
                if bi and aA(bq) then
                    bp(av().X)
                end
            end, bh
        )
        self.Window:_listen(
            'Ended',
            function(bq)
                if bi and aw(bq) then
                    bi = false
                    bh.Dragging = false
                    ah(bf, {Size = UDim2.fromOffset(12, 12)}, 0.2)
                    ah(be, {Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85}, 0.2)
                    aJ(aU.OnRelease, bh.Value)
                end
            end, bh
        )
        bh.Value = bj(bh.Value)
        bm(0)
        task.defer(bb, true)
        return m(self, aU, bh, a2, 'Slider')
    end
    function aS:Dropdown(aU)
        aU = l(
            aU,
            {
                Title = 'Name', Description = 'Desc', CurrentOption = 'Default', Value = 'Default',
                MultipleOptions = 'Multi', Values = 'Options'
            }
        )
        if aU.Multi and type(aU.Default) ~= 'table' and aU.Default ~= nil then
            aU.Default = {aU.Default}
        elseif not aU.Multi and type(aU.Default) == 'table' then
            aU.Default = aU.Default[1]
        end
        local aV = aU.Multi == true
        local aW = aU.Options or {}
        local aX, aY, aZ
        aU, aX, aY, aZ = aQ(self, aU, {}, 'Frame')
        local a_ = aM(self)
        local a0 = a_.Compact
        local a1 = a_.Chip
        local a2 = self.Window
        local a3 = E and 40 or 30
        local a4 = aU.MaxRows or 6
        local a5 = a0 and aU.Stacked == true
        local a6 = 2
        if a5 then
            a6 = (aU.Name or '') ~= '' and 20 or 2
            a1 = E and 34 or 30
            aZ = a6 + a1 + 4
            aX.Size = UDim2.new(1, 0, 0, aZ)
        end
        local a7 = ai(
            'TextButton',
            {
                Size = UDim2.new(1, 0, 0, aZ), BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, Parent = aX
            }
        )
        local a8, a9
        if not a5 then
            a8, a9 = aP(a7, aU.Name or 'Dropdown', aU.Desc, 180, a_)
        elseif a6 > 2 then
            a8 = am(
                {
                    Position = UDim2.fromOffset(14, 1), Size = UDim2.new(1, -28, 0, 16),
                    Text = aU.Name, TextSize = a_.TextSize, Parent = a7
                }
            )
        end
        local ba = ai(
            'Frame',
            {
                AnchorPoint = a5 and Vector2.zero or Vector2.new(1, 0.5),
                Position = a5 and UDim2.fromOffset(14, a6) or UDim2.new(
                    1, a0 and -14 or -10, 0.5, 0
                ), Size = UDim2.fromOffset(60, a1), BackgroundColor3 = z.Surface,
                BorderSizePixel = 0, ClipsDescendants = true, Parent = a7
            }
        )
        aj(ba, UDim.new(0, 6))
        local bb = ak(ba)
        local bc = am(
            {
                Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0),
                TextColor3 = z.Muted, TextSize = 13, TextTruncate = Enum.TextTruncate.None,
                ClipsDescendants = true, Parent = ba
            }
        )
        local bd = aC(ba, 1, -6)
        local be = am(
            {
                Size = UDim2.fromOffset(0, a1), AutomaticSize = Enum.AutomaticSize.X, TextSize = 13,
                Visible = false, Parent = ba
            }
        )
        local bf = ''
        local function bg()
            local bh = (a5 and aX.AbsoluteSize.X / a2.Scale.Scale - 28 or a0 and aN(aX, a2) or 190) - 10 - 34
            be.Text = bf
            if be.TextBounds.X <= bh then
                return bf
            end
            local bi = bf
            while #bi > 1 do
                bi = bi:sub(1, -2)
                be.Text = bi .. '..'
                if be.TextBounds.X <= bh then
                    return bi .. '..'
                end
            end
            return '..'
        end
        local function bh(bi)
            if a5 then
                ba.Size = UDim2.new(1, -28, 0, a1)
                return
            end
            local bj
            if a0 then
                bj = aN(aX, a2)
            else
                bj = math.clamp(bc.TextBounds.X + 10 + 34, 60, 190)
            end
            aR(a8, a9, bj + (a0 and 24 or 20))
            if bi then
                ba.Size = UDim2.fromOffset(bj, a1)
            else
                ah(ba, {Size = UDim2.fromOffset(bj, a1)}, 0.2)
            end
        end
        bc:GetPropertyChangedSignal('TextBounds'):Connect(
            function()
                if not a0 then
                    bh(false)
                end
            end
        )
        if a0 then
            local bi, bj = 0, false
            aX:GetPropertyChangedSignal('AbsoluteSize'):Connect(
                function()
                    local bk = aX.AbsoluteSize.X
                    if bk == bi then
                        return
                    end
                    bi = bk
                    bh(true)
                    if not bj then
                        bj = true
                        task.delay(
                            0.12,
                            function()
                                bj = false
                                bc.Text = bg()
                            end
                        )
                    end
                end
            )
        end
        local bi = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0), Size = UDim2.fromOffset(220, 0),
                BackgroundTransparency = 1, Visible = false, ZIndex = 45, Parent = a2.Body
            }
        )
        bi:SetAttribute('NoDrag', true)
        local bj = ai(
            'ImageLabel',
            {
                Position = UDim2.fromOffset(-18, -12), Size = UDim2.new(1, 36, 1, 36),
                BackgroundTransparency = 1, Image = A.Shadow, ImageColor3 = Color3.new(0, 0, 0),
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450), Parent = bi
            }
        )
        local bk = ai(
            'Frame',
            {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = z.Background, BorderSizePixel = 0,
                ClipsDescendants = true, Parent = bi
            }
        )
        aj(bk, UDim.new(0, 10))
        local bl = ak(bk, z.Stroke, 1)
        ao(bk)
        local bm = ai(
            'Frame', {Size = UDim2.new(1, 0, 0, 120), BackgroundTransparency = 1, Parent = bk}
        )
        al(bm, 8, 8, 8, 8)
        local bn = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = z.Surface, BorderSizePixel = 0, Parent = bm}
        )
        aj(bn, UDim.new(0, 7))
        local bo = ak(bn)
        local bp, bq = aB(bn, 'search', z.Muted, UDim2.new(0, 10, 0.5, 0))
        bp.Size = UDim2.fromOffset(14, 14)
        local br = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1, Text = '',
                PlaceholderText = aU.SearchPlaceholder or 'Search', PlaceholderColor3 = z.Muted,
                TextColor3 = z.Text, TextSize = 13, FontFace = D.Regular,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                ClearTextOnFocus = false, Parent = bn
            }
        )
        br.Focused:Connect(
            function()
                ah(bo, {Color = z.StrokeHover}, 0.15)
                ah(bq, {ImageColor3 = z.Accent}, 0.15)
            end
        )
        br.FocusLost:Connect(
            function()
                ah(bo, {Color = z.Stroke}, 0.2)
                ah(bq, {ImageColor3 = z.Muted}, 0.2)
            end
        )
        local bs = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1, Visible = aV, Parent = bm}
        )
        local function bt(bu, bv)
            local bw = ai(
                'TextButton',
                {
                    Position = bv, Size = UDim2.new(0.5, -3, 1, 0), BackgroundColor3 = z.Surface3,
                    BackgroundTransparency = 0.35, BorderSizePixel = 0, Text = '',
                    AutoButtonColor = false, ClipsDescendants = true, Parent = bs
                }
            )
            aj(bw, UDim.new(0, 6))
            local bx = ak(bw)
            am(
                {
                    Size = UDim2.fromScale(1, 1), Text = bu, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Center, Parent = bw
                }
            )
            bw.MouseEnter:Connect(
                function()
                    ah(bw, {BackgroundTransparency = 0.05}, 0.15)
                    ah(bx, {Color = z.StrokeHover}, 0.15)
                end
            )
            bw.MouseLeave:Connect(
                function()
                    ah(bw, {BackgroundTransparency = 0.35}, 0.25)
                    ah(bx, {Color = z.Stroke}, 0.25)
                end
            )
            bw.MouseButton1Click:Connect(
                function()
                    aE(bw)
                end
            )
            return bw
        end
        local bu = bt(aU.SelectAllText or 'Select all', UDim2.fromOffset(0, 0))
        local bv = bt(aU.ClearAllText or 'Clear all', UDim2.new(0.5, 3, 0, 0))
        local bw = ai(
            'ScrollingFrame',
            {
                Size = UDim2.new(1, 0, 0, 100), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = E and 4 or 3, ScrollBarImageColor3 = z.Accent,
                ScrollBarImageTransparency = 0.4, ScrollingDirection = Enum.ScrollingDirection.Y,
                CanvasSize = UDim2.new(), Parent = bm
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = bw}
        )
        local bx = am(
            {
                Size = UDim2.new(1, 0, 0, a3), Text = aU.NoResultsText or 'No results',
                TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 0, Visible = false,
                Parent = bw
            }
        )
        local by = {Open = false}
        local bz = {}
        local bA = {}
        local bB = ''
        local function bC(bD)
            return bB == '' or string.find(string.lower(tostring(bD)), bB, 1, true) ~= nil
        end
        local function bD(bE)
            return (bE:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'))
        end
        local function bE(bF)
            local bG = tostring(bF)
            local bH = bB ~= '' and string.find(string.lower(bG), bB, 1, true)
            if not bH then
                return bD(bG)
            end
            local bI = bH + #bB - 1
            return bD(bG:sub(1, bH - 1)) .. '<font color="#' .. z.Accent:ToHex() .. '"><b>' .. bD(
                bG:sub(bH, bI)
            ) .. '</b></font>' .. bD(bG:sub(bI + 1))
        end
        if aV then
            for bF, bG in ipairs(aU.Default or {}) do
                bz[bG] = true
            end
        elseif aU.Default ~= nil then
            bz[aU.Default] = true
        end
        local function bF()
            if aV then
                local bG = {}
                for bH, bI in ipairs(aW) do
                    if bz[bI] then
                        table.insert(bG, bI)
                    end
                end
                return bG
            end
            for bG, bH in ipairs(aW) do
                if bz[bH] then
                    return bH
                end
            end
            return nil
        end
        local function bG(bH, bI)
            local bJ, bK = bH.On == true, bH.Hover == true
            ah(
                bH.Frame,
                {
                    BackgroundColor3 = bJ and z.Accent or z.Surface3,
                    BackgroundTransparency = bJ and (bK and 0.8 or 0.88) or (bK and 0.55 or 1)
                }, bI
            )
            ah(bH.Label, {TextColor3 = (bJ or bK) and z.Text or z.Muted}, bI)
        end
        local function bH(bI, bJ)
            local bK = bz[bI.Option] == true
            if bI.On == bK and bJ then
                return
            end
            bI.On = bK
            local bL = bJ and 0.18 or 0
            bG(bI, bL)
            if aV then
                ah(bI.Box, {BackgroundColor3 = bK and z.Accent or z.Surface2}, bL)
                ah(bI.BoxStroke, {Color = bK and z.Accent or z.Stroke}, bL)
            else
                ah(
                    bI.Bar,
                    {BackgroundTransparency = bK and 0 or 1, Size = UDim2.fromOffset(
                        3, bK and a3 - 14 or 4
                    )}, bJ and 0.3 or 0, Enum.EasingStyle.Quint
                )
            end
            ah(bI.Check, {ImageTransparency = bK and 0 or 1}, bL)
            if bJ and bK then
                bI.CheckScale.Scale = 0.5
                ah(bI.CheckScale, {Scale = 1}, 0.3, Enum.EasingStyle.Back)
            else
                bI.CheckScale.Scale = 1
            end
        end
        local function bI(bJ)
            local bK = bF()
            if #aW == 0 then
                bf = aU.EmptyText or 'None'
            elseif aV then
                if #bK > 2 then
                    bf = tostring(bK[1]) .. ', ' .. tostring(bK[2]) .. '  +' .. (#bK - 2)
                else
                    bf = #bK > 0 and table.concat(bK, ', ') or (aU.NoneText or 'None')
                end
            else
                bf = bK ~= nil and tostring(bK) or (aU.NoneText or 'None')
            end
            bc.Text = bg()
            local bL = #aW > 0 and (if aV then #bK > 0 else bK ~= nil)
            ah(bc, {TextColor3 = bL and z.Text or z.Muted}, bJ and 0.15 or 0)
            for bM, bN in pairs(bA) do
                bH(bN, bJ)
            end
        end
        local function bJ()
            local bK = 0
            for bL, bM in ipairs(aW) do
                if bC(bM) then
                    bK += 1
                end
            end
            return bK
        end
        local bK = true
        local bL = Vector2.new(220, 120)
        local bM = false
        local function bN(bO)
            bK = aU.Searchable ~= false and #aW > (aU.SearchAfter or 0)
            bn.Visible = bK
            local bP = 0
            if bK then
                bP += 38
            end
            bs.Position = UDim2.fromOffset(0, bP)
            if aV and #aW > 0 then
                bs.Visible = true
                bP += 34
            else
                bs.Visible = false
            end
            local bQ = bJ()
            bx.Visible = bQ == 0
            local bR = math.clamp(bQ, 1, a4)
            local bS = bR * a3 + (bR - 1) * 2
            bw.CanvasSize = UDim2.fromOffset(0, math.max(bQ, 1) * (a3 + 2) - 2)
            local bT = a2.Scale.Scale
            local bU = a2:_popupHost(aX)
            local bV = bU.AbsoluteSize.Y / bT
            local bW = (ba.AbsolutePosition.Y - bU.AbsolutePosition.Y) / bT
            local bX = math.max(bV - (bW + ba.AbsoluteSize.Y / bT) - 14, bW - 14) - bP - 16
            if bX >= a3 then
                bS = math.min(bS, bX)
            end
            bw.Position = UDim2.fromOffset(0, bP)
            bw.Size = UDim2.new(1, 0, 0, bS)
            local bY = math.max(math.floor(ba.AbsoluteSize.X / bT), aU.PopupWidth or 210)
            local bZ = bU.AbsoluteSize.X / bT
            bY = math.min(bY, math.max(bZ - 16, 120))
            bL = Vector2.new(bY, bP + bS + 16)
            bm.Size = UDim2.new(1, 0, 0, bL.Y)
            if not bM then
                return
            end
            if bO then
                bi.Size = UDim2.fromOffset(bL.X, bL.Y)
            else
                ah(bi, {Size = UDim2.fromOffset(bL.X, bL.Y)}, 0.22, Enum.EasingStyle.Quint)
            end
        end
        local function bO()
            for bP, bQ in pairs(bA) do
                local bR = bC(bP)
                bQ.Frame.Visible = bR
                if bR then
                    bQ.Label.Text = bE(bP)
                end
            end
        end
        local bP = nil
        local function bQ()
            local bR = a2:_popupHost(aX)
            local bS = a2.Scale.Scale
            if bP then
                local bT = ba.AbsolutePosition + ba.AbsoluteSize / 2
                if not az(bT, bP) then
                    by:SetOpen(false)
                    return
                end
            end
            local bT = bR.AbsoluteSize / bS
            local bU = (ba.AbsolutePosition - bR.AbsolutePosition) / bS
            local bV = ba.AbsoluteSize / bS
            local bW = math.clamp(bU.X + bV.X, bL.X + 8, math.max(bT.X - 8, bL.X + 8))
            local bX = bU.Y + bV.Y + 6
            if bX + bL.Y > bT.Y - 8 and bU.Y - 6 - bL.Y >= 8 then
                bi.AnchorPoint = Vector2.new(1, 1)
                bi.Position = UDim2.fromOffset(bW, bU.Y - 6)
                bm.AnchorPoint = Vector2.new(0, 1)
                bm.Position = UDim2.fromScale(0, 1)
            else
                bi.AnchorPoint = Vector2.new(1, 0)
                bi.Position = UDim2.fromOffset(bW, bX)
                bm.AnchorPoint = Vector2.zero
                bm.Position = UDim2.fromScale(0, 0)
            end
        end
        local bR = nil
        local bS = 0
        local bT = nil
        local function bU()
            if bT then
                bT.ScrollingEnabled = true
                bT = nil
            end
        end
        local function bV()
            bw.CanvasPosition = Vector2.zero
            if aV then
                return
            end
            local bW = bF()
            if bW == nil then
                return
            end
            for bX, bY in ipairs(aW) do
                if bY == bW then
                    bw.CanvasPosition = Vector2.new(0, math.max(0, (bX - 2) * (a3 + 2)))
                    return
                end
            end
        end
        local function bW(bX)
            if bX == by.Open then
                return
            end
            by.Open = bX
            bd:Set(bX)
            ah(bb, {Color = bX and z.Accent or z.Stroke, Transparency = bX and 0.35 or 0}, 0.2)
            ah(ba, {BackgroundColor3 = bX and z.Surface2 or z.Surface}, 0.2)
            bS += 1
            if bX then
                if a2._closePopup and a2._closePopup ~= by._close then
                    a2._closePopup()
                end
                a2._closePopup = by._close
                bP = aX:FindFirstAncestorWhichIsA('ScrollingFrame')
                if bP and bP.ScrollingEnabled then
                    bT = bP
                    bP.ScrollingEnabled = false
                end
                bi.Parent = a2:_popupHost(aX)
                bB = ''
                br.Text = ''
                br.PlaceholderText = aU.SearchPlaceholder or (#aW > 6 and ('Search ' .. #aW .. ' options') or 'Search')
                bO()
                bN(true)
                bI(false)
                bV()
                bM = true
                bi.Size = UDim2.fromOffset(bL.X, 0)
                bQ()
                bi.Visible = true
                ah(bi, {Size = UDim2.fromOffset(bL.X, bL.Y)}, 0.3, Enum.EasingStyle.Quint)
                ah(bl, {Transparency = 0}, 0.12)
                ah(bj, {ImageTransparency = 0.4}, 0.3)
                if not bR then
                    bR = a2:_listen('Render', bQ)
                end
            else
                if a2._closePopup == by._close then
                    a2._closePopup = nil
                end
                bU()
                if br:IsFocused() then
                    br:ReleaseFocus()
                end
                bM = false
                ah(bi, {Size = UDim2.fromOffset(bL.X, 0)}, 0.2, Enum.EasingStyle.Quint)
                ah(bj, {ImageTransparency = 1}, 0.16)
                local bY = bS
                task.delay(
                    0.14,
                    function()
                        if bS == bY and not by.Open then
                            ah(bl, {Transparency = 1}, 0.06)
                        end
                    end
                )
                task.delay(
                    0.21,
                    function()
                        if bS == bY and not by.Open then
                            bi.Visible = false
                            if bR then
                                bR()
                                bR = nil
                            end
                        end
                    end
                )
            end
        end
        by._close = function()
            bW(false)
        end
        local function bX()
            bI(true)
            aJ(aU.Callback, bF())
        end
        local function bY()
            local bZ = {}
            for b_, b0 in ipairs(aW) do
                bZ[b0] = b_
            end
            for b_, b0 in pairs(bA) do
                if not bZ[b_] then
                    b0.Frame:Destroy()
                    bA[b_] = nil
                end
            end
            for b_, b0 in ipairs(aW) do
                local b1 = bA[b0]
                if b1 then
                    b1.Frame.LayoutOrder = b_
                    continue
                end
                local b2 = ai(
                    'TextButton',
                    {
                        Size = UDim2.new(1, -6, 0, a3), BackgroundColor3 = z.Surface3,
                        BackgroundTransparency = 1, BorderSizePixel = 0, Text = '',
                        AutoButtonColor = false, LayoutOrder = b_, Parent = bw
                    }
                )
                aj(b2, UDim.new(0, 7))
                local b3, b4, b5, b6
                if aV then
                    b3 = ai(
                        'Frame',
                        {
                            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                            Size = UDim2.fromOffset(18, 18), BackgroundColor3 = z.Surface2,
                            BorderSizePixel = 0, Parent = b2
                        }
                    )
                    aj(b3, UDim.new(0, 5))
                    b4 = ak(b3, z.Stroke)
                    b6 = ai(
                        'ImageLabel',
                        {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 12),
                            BackgroundTransparency = 1, ImageColor3 = z.AccentDark,
                            ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit, Parent = b3
                        }
                    )
                else
                    b5 = ai(
                        'Frame',
                        {
                            AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0),
                            Size = UDim2.fromOffset(3, 4), BackgroundColor3 = z.Accent,
                            BackgroundTransparency = 1, BorderSizePixel = 0, Parent = b2
                        }
                    )
                    aj(b5, UDim.new(1, 0))
                    b6 = ai(
                        'ImageLabel',
                        {
                            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                            Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                            ImageColor3 = z.Accent, ImageTransparency = 1,
                            ScaleType = Enum.ScaleType.Fit, Parent = b2
                        }
                    )
                end
                aq(b6, 'check')
                local b7 = ai('UIScale', {Parent = b6})
                local b8 = am(
                    {
                        Position = UDim2.fromOffset(aV and 36 or 14, 0),
                        Size = UDim2.new(1, aV and -44 or -46, 1, 0), Text = bE(b0), TextSize = 13,
                        TextColor3 = z.Muted, RichText = true, Parent = b2
                    }
                )
                local b9 = {
                    Option = b0, Frame = b2, Box = b3, BoxStroke = b4, Bar = b5, Check = b6,
                    CheckScale = b7, Label = b8, On = nil, Hover = false
                }
                local ca = ay(
                    b2,
                    function()
                        return bw
                    end
                )
                b2.MouseEnter:Connect(
                    function()
                        if ax() then
                            return
                        end
                        b9.Hover = true
                        bG(b9, 0.15)
                        if b4 and not bz[b0] then
                            ah(b4, {Color = z.StrokeHover}, 0.15)
                        end
                    end
                )
                b2.MouseLeave:Connect(
                    function()
                        b9.Hover = false
                        bG(b9, 0.25)
                        if b4 and not bz[b0] then
                            ah(b4, {Color = z.Stroke}, 0.25)
                        end
                    end
                )
                b2.MouseButton1Click:Connect(
                    function()
                        if not ca() then
                            return
                        end
                        if bz[b0] then
                            if not aV and aU.AllowNone == false then
                                bW(false)
                                return
                            end
                            bz[b0] = nil
                        else
                            if not aV then
                                bz = {}
                            end
                            bz[b0] = true
                        end
                        bX()
                        if not aV then
                            bW(false)
                        end
                    end
                )
                bA[b0] = b9
                bH(b9, false)
            end
            bO()
            if by.Open then
                bN(false)
            end
        end
        bu.MouseButton1Click:Connect(
            function()
                for bZ, b_ in ipairs(aW) do
                    if bC(b_) then
                        bz[b_] = true
                    end
                end
                bX()
            end
        )
        bv.MouseButton1Click:Connect(
            function()
                bz = {}
                bX()
            end
        )
        function by:Set(bZ, b_)
            bz = {}
            if aV then
                for b0, b1 in ipairs(type(bZ) == 'table' and bZ or {bZ}) do
                    bz[b1] = true
                end
            elseif bZ ~= nil then
                bz[bZ] = true
            end
            bI(by.Open)
            aF(aY)
            if not b_ then
                aJ(aU.Callback, bF())
            end
        end
        function by:Get()
            return bF()
        end
        local function bZ(b_, b0)
            if type(b_) ~= 'table' or type(b0) ~= 'table' then
                return b_ == b0
            end
            if #b_ ~= #b0 then
                return false
            end
            for b1, b2 in ipairs(b_) do
                if b0[b1] ~= b2 then
                    return false
                end
            end
            return true
        end
        function by:Refresh(b_, b0, b1)
            local b2 = bF()
            aW = b_ or {}
            if not b0 then
                bz = {}
            end
            bY()
            bI(false)
            if not b1 and not bZ(b2, bF()) then
                aJ(aU.Callback, bF())
            end
        end
        function by:_saveValue()
            local b_ = bF()
            if aV then
                local b0 = {}
                for b1, b2 in ipairs(b_) do
                    b0[b2] = true
                end
                for b1 in pairs(bz) do
                    if not b0[b1] then
                        table.insert(b_, b1)
                    end
                end
                return b_
            end
            if b_ == nil then
                b_ = next(bz)
            end
            return b_
        end
        function by:SetOpen(b_)
            bW(b_ == true)
        end
        local b_ = ay(
            a7,
            function()
                return aX:FindFirstAncestorWhichIsA('ScrollingFrame')
            end
        )
        a7.MouseButton1Click:Connect(
            function()
                if b_() then
                    bW(not by.Open)
                end
            end
        )
        a7.MouseEnter:Connect(
            function()
                if not by.Open and not ax() then
                    ah(bb, {Color = z.StrokeHover}, 0.15)
                    ah(ba, {BackgroundColor3 = z.Surface2}, 0.15)
                end
            end
        )
        a7.MouseLeave:Connect(
            function()
                if not by.Open then
                    ah(bb, {Color = z.Stroke}, 0.25)
                    ah(ba, {BackgroundColor3 = z.Surface}, 0.25)
                end
            end
        )
        br:GetPropertyChangedSignal('Text'):Connect(
            function()
                bB = string.lower(br.Text)
                bO()
                if by.Open then
                    bN(false)
                end
            end
        )
        by._listeners = {
            function()
                bW(false)
                bU()
                if bR then
                    bR()
                    bR = nil
                end
                bi:Destroy()
            end
        }
        a2:_listen(
            'Began',
            function(b0)
                if not by.Open then
                    return
                end
                if b0.KeyCode == Enum.KeyCode.Escape then
                    bW(false)
                elseif aw(b0) then
                    local b1 = av()
                    if not az(b1, bi) and not az(b1, a7) then
                        bW(false)
                    end
                end
            end, by
        )
        bY()
        bI(false)
        task.defer(bh, true)
        return m(self, aU, by, aX, 'Dropdown')
    end
    k._amountSuffixes = {k = 1e3, m = 1e6, b = 1e9, t = 1e12, qa = 1e15, qi = 1e18}
    function k._parseAmount(aU)
        aU = string.lower(tostring(aU)):gsub('[%s,_%$]', '')
        aU = aU:gsub('kg$', ''):gsub('/s$', '')
        local aV = tonumber(aU)
        if aV then
            return aV
        end
        local aW, aX = aU:match('^(.-)(%a+)$')
        local aY = aX and k._amountSuffixes[aX]
        aV = aW and tonumber(aW)
        if aV and aY then
            return aV * aY
        end
        return nil
    end
    function aS:Input(aU)
        local aV, aW, aX, aY, aZ
        aU, aV, aW, aX, aY, aZ = aQ(
            self, aU,
            {
                Title = 'Name', Description = 'Desc', PlaceholderText = 'Placeholder',
                CurrentValue = 'Default', Value = 'Default'
            }, 'Frame', 160, 'Input'
        )
        local a_ = aM(self).Compact
        local a0 = a_ and aM(self).Chip + 2 or 30
        local a1 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, a_ and -14 or -10, 0.5, 0),
                Size = UDim2.fromOffset(170, a0), BackgroundColor3 = z.Surface, BorderSizePixel = 0,
                Parent = aV
            }
        )
        aj(a1, UDim.new(0, 6))
        local a2 = ak(a1)
        local a3 = aU.Icon
        if a3 then
            aB(a1, a3, z.Muted, UDim2.new(0, 8, 0.5, 0))
        end
        local a4 = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(a3 and 30 or 8, 0),
                Size = UDim2.new(1, a3 and -38 or -16, 1, 0), BackgroundTransparency = 1,
                Text = aU.Default or '', PlaceholderText = aU.Placeholder or '',
                PlaceholderColor3 = z.Muted, TextColor3 = z.Text, TextSize = a_ and 13 or 14,
                FontFace = D.Regular, TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false, TextTruncate = Enum.TextTruncate.None,
                ClipsDescendants = true, Parent = a1
            }
        )
        a1.ClipsDescendants = true
        local a5 = a4.Text
        local a6 = aU.Numeric and k._parseAmount(a5) or nil
        if aU.Numeric and not a6 then
            a5 = ''
        end
        local a7 = false
        local a8 = (a3 and 30 or 8) + 8
        local function a9(ba)
            local bb
            if a_ then
                bb = aN(aV, self.Window)
            else
                local bc = aV.AbsoluteSize.X / self.Window.Scale.Scale
                local bd = math.clamp(bc - 14 - 110 - 20, 100, 200)
                local be = a4.TextBounds.X
                if #a4.Text == 0 then
                    be = math.min(a4.TextBounds.X, 90)
                end
                bb = math.clamp(be + a8 + 12, 90, bd) + (a7 and 8 or 0)
                bb = math.min(bb, bd + 8)
            end
            aR(aY, aZ, bb + (a_ and 24 or 20))
            if ba then
                a1.Size = UDim2.fromOffset(bb, a0)
            else
                ah(a1, {Size = UDim2.fromOffset(bb, a0)}, 0.18)
            end
        end
        local ba = 0
        aV:GetPropertyChangedSignal('AbsoluteSize'):Connect(
            function()
                if aV.AbsoluteSize.X ~= ba then
                    ba = aV.AbsoluteSize.X
                    a9(true)
                end
            end
        )
        a4:GetPropertyChangedSignal('Text'):Connect(
            function()
                a9(false)
            end
        )
        a4:GetPropertyChangedSignal('TextBounds'):Connect(
            function()
                a9(false)
            end
        )
        task.defer(a9, true)
        a4.Focused:Connect(
            function()
                a7 = true
                ah(a2, {Color = z.StrokeHover}, 0.15)
                a9(false)
            end
        )
        a4.FocusLost:Connect(
            function(bb)
                a7 = false
                ah(a2, {Color = z.Stroke}, 0.15)
                a9(false)
                if aU.Numeric then
                    local bc = k._parseAmount(a4.Text)
                    if not bc then
                        a4.Text = a5
                        return
                    end
                    a5, a6 = a4.Text, bc
                    aJ(aU.Callback, bc, bb)
                    return
                end
                aJ(aU.Callback, a4.Text, bb)
            end
        )
        return m(
            self, aU,
            {
                Set = function(bb, bc)
                    a4.Text = tostring(bc)
                    if aU.Numeric then
                        local bd = k._parseAmount(a4.Text)
                        if bd then
                            a5, a6 = a4.Text, bd
                        else
                            a4.Text = a5
                        end
                    end
                    aF(aW)
                end,
                Get = function()
                    if aU.Numeric then
                        return a6
                    end
                    return a4.Text
                end,
                _saveValue = aU.Numeric and function()
                    return a5
                end or nil
            }, aV, 'Input'
        )
    end
    function aS:Keybind(aU)
        local aV, aW, aX, aY, aZ
        aU, aV, aW, aX, aY, aZ = aQ(
            self, aU,
            {Title = 'Name', Description = 'Desc', CurrentKeybind = 'Default', Value = 'Default'},
            'Frame', 110, 'Keybind'
        )
        if type(aU.Default) == 'string' then
            aU.Default = Enum.KeyCode[aU.Default]
        end
        local a_ = aM(self).Compact
        local a0 = aM(self).Chip
        local a1 = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, a_ and -14 or -10, 0.5, 0), Size = UDim2.fromOffset(44, a0),
                BackgroundColor3 = z.Surface, BorderSizePixel = 0, Text = '',
                AutoButtonColor = false, ClipsDescendants = true, Parent = aV
            }
        )
        aj(a1, UDim.new(0, 6))
        local a2 = ak(a1)
        local a3 = am(
            {
                Size = UDim2.new(1, 0, 1, 0), TextSize = 13, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None,
                Parent = a1
            }
        )
        local a4 = {Value = aU.Default, Listening = false}
        local function a5(a6)
            local a7 = math.max(a3.TextBounds.X + 20, E and 44 or 36)
            aR(aY, aZ, a7 + (a_ and 24 or 20))
            if a6 then
                a1.Size = UDim2.fromOffset(a7, a0)
            else
                ah(a1, {Size = UDim2.fromOffset(a7, a0)}, 0.2)
            end
        end
        a3:GetPropertyChangedSignal('TextBounds'):Connect(
            function()
                a5(false)
            end
        )
        local function a6()
            a3.Text = a4.Listening and '...' or aI(a4.Value)
            ah(a2, {Color = a4.Listening and z.StrokeHover or z.Stroke}, 0.15)
            ah(a3, {TextColor3 = a4.Listening and z.Accent or z.Muted}, 0.15)
        end
        function a4:Set(a7, a8)
            local a9 = a4.Listening
            a4.Value = a7
            a4.Listening = false
            a6()
            if not a9 then
                aF(aW)
            end
            if not a8 then
                aJ(aU.OnChanged, a7)
            end
        end
        a1.MouseButton1Click:Connect(
            function()
                a4.Listening = not a4.Listening
                a6()
            end
        )
        self.Window:_listen(
            'Began',
            function(a7, a8)
                if a7.UserInputType ~= Enum.UserInputType.Keyboard then
                    return
                end
                if a4.Listening then
                    self.Window._consumedKey = a7.KeyCode
                    self.Window._consumedAt = os.clock()
                    if a7.KeyCode == Enum.KeyCode.Escape then
                        a4.Listening = false
                        a6()
                    else
                        a4:Set(a7.KeyCode)
                    end
                    return
                end
                if not a8 and a4.Value ~= nil and a7.KeyCode == a4.Value then
                    aJ(aU.Callback, a7.KeyCode)
                end
            end, a4
        )
        a6()
        task.defer(a5, true)
        function a4:Get()
            return a4.Value
        end
        a4._onHide = function()
            if a4.Listening then
                a4.Listening = false
                a6()
            end
        end
        return m(self, aU, a4, aV, 'Keybind')
    end
    function aS:ColorPicker(aU)
        local aV = 194
        local aW, aX, aY
        aU, aW, aX, aY = aQ(
            self, aU,
            {
                Title = 'Name', Description = 'Desc', Color = 'Default', CurrentValue = 'Default',
                Value = 'Default'
            }, 'Frame'
        )
        aW.ClipsDescendants = true
        local aZ = aM(self)
        local a_ = aZ.Compact
        local a0 = ai(
            'TextButton',
            {
                Size = UDim2.new(1, 0, 0, aY), BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, Parent = aW
            }
        )
        aP(a0, aU.Name or 'Color', aU.Desc, 140, aZ)
        local a1 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, a_ and -38 or -34, 0.5, 0), Size = UDim2.fromOffset(22, 22),
                BorderSizePixel = 0, Parent = a0
            }
        )
        aj(a1, UDim.new(0, 6))
        ak(a1, z.Stroke)
        local a2 = am(
            {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, a_ and -68 or -64, 0.5, 0), Size = UDim2.fromOffset(64, 16),
                TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Right, Parent = a0
            }
        )
        local a3 = aC(a0, 1, a_ and -14 or -12)
        local a4 = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(14, aY + 2), Size = UDim2.new(1, -28, 0, aV - 12),
                BackgroundTransparency = 1, Visible = false, Parent = aW
            }
        )
        local a5 = ai(
            'TextButton',
            {
                Size = UDim2.new(1, 0, 0, 118), BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0, Text = '', AutoButtonColor = false, Parent = a4
            }
        )
        aj(a5, UDim.new(0, 8))
        ak(a5, z.Stroke)
        local a6 = ai(
            'UIGradient',
            {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 0, 0)), Parent = a5}
        )
        local a7 = ai(
            'Frame',
            {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0, Parent = a5
            }
        )
        aj(a7, UDim.new(0, 8))
        ai(
            'UIGradient',
            {
                Transparency = NumberSequence.new(
                    {NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}
                ), Rotation = 90, Parent = a7
            }
        )
        local function a8(a9, ba)
            local bb = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(ba, ba),
                    BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 3,
                    Parent = a9
                }
            )
            aj(bb, UDim.new(1, 0))
            ak(bb, Color3.new(0, 0, 0), 0.7)
            local bc = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.new(1, -4, 1, -4), BorderSizePixel = 0, ZIndex = 3, Parent = bb
                }
            )
            aj(bc, UDim.new(1, 0))
            return bb, bc
        end
        local a9, ba = a8(a5, 14)
        local bb = ai(
            'TextButton',
            {
                Position = UDim2.fromOffset(0, 132), Size = UDim2.new(1, 0, 0, 10),
                BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Text = '',
                AutoButtonColor = false, Parent = a4
            }
        )
        aj(bb, UDim.new(1, 0))
        ai(
            'UIGradient',
            {
                Color = ColorSequence.new(
                    {
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }
                ), Parent = bb
            }
        )
        local bc, bd = a8(bb, 16)
        bc.Position = UDim2.fromScale(0, 0.5)
        local be = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(0, 154), Size = UDim2.fromOffset(a_ and 110 or 124, 28),
                BackgroundColor3 = z.Surface, BorderSizePixel = 0, Parent = a4
            }
        )
        aj(be, UDim.new(0, 7))
        local bf = ak(be)
        local bg = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0),
                Size = UDim2.fromOffset(16, 16), BorderSizePixel = 0, Parent = be
            }
        )
        aj(bg, UDim.new(0, 4))
        ak(bg, z.Stroke)
        local bh = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -38, 1, 0),
                BackgroundTransparency = 1, Text = '', TextTruncate = Enum.TextTruncate.None,
                ClipsDescendants = false, TextColor3 = z.Text, TextSize = 13, FontFace = D.Regular,
                TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Parent = be
            }
        )
        local bi = am(
            {
                Position = UDim2.fromOffset(a_ and 118 or 134, 154),
                Size = UDim2.new(1, a_ and -118 or -134, 0, 28),
                TextXAlignment = Enum.TextXAlignment.Right, TextSize = 12, FontFace = D.Regular,
                TextColor3 = z.Muted, Parent = a4
            }
        )
        local bj = {Open = false}
        local bk, bl, bm = Color3.toHSV(aU.Default or z.Accent)
        local bn = nil
        local function bo(bp)
            return string.format(
                '#%02X%02X%02X', math.floor(bp.R * 255 + 0.5), math.floor(bp.G * 255 + 0.5),
                math.floor(bp.B * 255 + 0.5)
            )
        end
        local function bp(bq)
            local br = Color3.fromHSV(bk, bl, bm)
            bj.Value = br
            a1.BackgroundColor3 = br
            bg.BackgroundColor3 = br
            ba.BackgroundColor3 = br
            bd.BackgroundColor3 = Color3.fromHSV(bk, 1, 1)
            a2.Text = bo(br)
            a6.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(bk, 1, 1))
            ah(a9, {Position = UDim2.fromScale(bl, 1 - bm)}, bq, Enum.EasingStyle.Quint)
            ah(bc, {Position = UDim2.fromScale(bk, 0.5)}, bq, Enum.EasingStyle.Quint)
            if not bh:IsFocused() then
                bh.Text = bo(br)
            end
            bi.Text = string.format(
                '%d  %d  %d', math.floor(br.R * 255 + 0.5), math.floor(br.G * 255 + 0.5),
                math.floor(br.B * 255 + 0.5)
            )
        end
        local function bq(br, bs)
            bp(br)
            if not bs then
                aJ(aU.Callback, bj.Value)
            end
        end
        function bj:Set(br, bs)
            bk, bl, bm = Color3.toHSV(br)
            bq(0.25, bs)
            aF(aX)
        end
        function bj:Get()
            return bj.Value
        end
        local function br(bs)
            bj.Open = bs
            ah(
                aW, {Size = UDim2.new(1, 0, 0, bs and (aY + aV) or aY)}, 0.35,
                Enum.EasingStyle.Quint
            )
            a3:Set(bs)
            if bs then
                a4.Visible = true
            else
                task.delay(
                    0.35,
                    function()
                        if not bj.Open then
                            a4.Visible = false
                        end
                    end
                )
            end
        end
        function bj:SetOpen(bs)
            br(bs == true)
        end
        a0.MouseButton1Click:Connect(
            function()
                br(not bj.Open)
            end
        )
        local function bs(bt)
            bl = math.clamp((bt.X - a5.AbsolutePosition.X) / a5.AbsoluteSize.X, 0, 1)
            bm = 1 - math.clamp((bt.Y - a5.AbsolutePosition.Y) / a5.AbsoluteSize.Y, 0, 1)
            bq(0.04)
        end
        local function bt(bu)
            bk = math.clamp((bu.X - bb.AbsolutePosition.X) / bb.AbsoluteSize.X, 0, 0.999)
            bq(0.04)
        end
        a5.InputBegan:Connect(
            function(bu)
                if aw(bu) then
                    bn = 'sv'
                    ah(a9, {Size = UDim2.fromOffset(18, 18)}, 0.2, Enum.EasingStyle.Quint)
                    bs(av())
                end
            end
        )
        bb.InputBegan:Connect(
            function(bu)
                if aw(bu) then
                    bn = 'hue'
                    ah(bc, {Size = UDim2.fromOffset(20, 20)}, 0.2, Enum.EasingStyle.Quint)
                    bt(av())
                end
            end
        )
        self.Window:_listen(
            'Changed',
            function(bu)
                if not bn or not aA(bu) then
                    return
                end
                local bv = av()
                if bn == 'sv' then
                    bs(bv)
                else
                    bt(bv)
                end
            end, bj
        )
        self.Window:_listen(
            'Ended',
            function(bu)
                if bn and aw(bu) then
                    bn = nil
                    ah(a9, {Size = UDim2.fromOffset(14, 14)}, 0.25, Enum.EasingStyle.Quint)
                    ah(bc, {Size = UDim2.fromOffset(16, 16)}, 0.25, Enum.EasingStyle.Quint)
                end
            end, bj
        )
        bh.Focused:Connect(
            function()
                ah(bf, {Color = z.StrokeHover}, 0.15)
            end
        )
        bh.FocusLost:Connect(
            function()
                ah(bf, {Color = z.Stroke}, 0.15)
                local bu, bv, bw = bh.Text:match('^%s*#?(%x%x)(%x%x)(%x%x)%s*$')
                if bu then
                    bj:Set(Color3.fromRGB(tonumber(bu, 16), tonumber(bv, 16), tonumber(bw, 16)))
                else
                    bh.Text = bo(bj.Value)
                end
            end
        )
        bp(0)
        return m(self, aU, bj, aW, 'ColorPicker')
    end
    function aS:Stepper(aU)
        local aV, aW, aX, aY, aZ
        aU, aV, aW, aX, aY, aZ = aQ(
            self, aU,
            {
                Title = 'Name', Description = 'Desc', CurrentValue = 'Default', Value = 'Default',
                Increment = 'Step'
            }, 'Frame', 150, 'Stepper'
        )
        local a_ = aU.Min or 0
        local a0 = aU.Max or 100
        local a1 = aU.Step or 1
        local a2 = aU.Suffix or ''
        local a3 = aL(a_, a0, a1)
        local a4 = aM(self).Compact
        local a5 = aM(self).Chip
        local a6 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, a4 and -14 or -10, 0.5, 0), Size = UDim2.fromOffset(0, a5),
                AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = z.Surface,
                BorderSizePixel = 0, Parent = aV
            }
        )
        aj(a6, UDim.new(0, 6))
        local a7 = ak(a6)
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center, Parent = a6
            }
        )
        local function a8(a9, ba)
            local bb = ai(
                'TextButton',
                {
                    Size = UDim2.fromOffset(a5, a5), BackgroundTransparency = 1, Text = a9,
                    TextColor3 = z.Muted, TextSize = 18, FontFace = D.Medium,
                    AutoButtonColor = false, LayoutOrder = ba, Parent = a6
                }
            )
            bb.MouseEnter:Connect(
                function()
                    ah(bb, {TextColor3 = z.Accent}, 0.12)
                end
            )
            bb.MouseLeave:Connect(
                function()
                    ah(bb, {TextColor3 = z.Muted}, 0.2)
                end
            )
            return bb
        end
        local a9 = a8('\u{2212}', 1)
        local ba = am(
            {
                Size = UDim2.new(0, 30, 1, 0), TextSize = 13, TextColor3 = z.Accent,
                TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None,
                LayoutOrder = 2, Parent = a6
            }
        )
        local bb = a8('+', 3)
        local function bc(bd)
            local be = math.max(ba.TextBounds.X + 12, 30)
            if bd then
                ba.Size = UDim2.new(0, be, 1, 0)
            else
                ah(ba, {Size = UDim2.new(0, be, 1, 0)}, 0.2)
            end
        end
        ba:GetPropertyChangedSignal('TextBounds'):Connect(
            function()
                bc(false)
            end
        )
        a6:GetPropertyChangedSignal('AbsoluteSize'):Connect(
            function()
                aR(aY, aZ, a6.AbsoluteSize.X / self.Window.Scale.Scale + (a4 and 24 or 20))
            end
        )
        local bd = {Value = math.clamp(aU.Default or a_, a_, a0)}
        local be = a3.snap
        local bf = false
        local function bg()
            ba.Text = a3.format(bd.Value) .. a2
            ah(a9, {TextTransparency = bd.Value <= a_ and 0.6 or 0}, 0.15)
            ah(bb, {TextTransparency = bd.Value >= a0 and 0.6 or 0}, 0.15)
        end
        function bd:Set(bh, bi)
            bh = be(tonumber(bh) or a_)
            if bh == bd.Value then
                return
            end
            bd.Value = bh
            bg()
            if not bf then
                aF(aW)
            end
            if not bi then
                aJ(aU.Callback, bh)
            end
        end
        function bd:Get()
            return bd.Value
        end
        local function bh(bi)
            bf = true
            bd:Set(bd.Value + bi * a1)
            bf = false
            ah(a7, {Color = z.StrokeHover}, 0.08)
            task.delay(
                0.12,
                function()
                    ah(a7, {Color = z.Stroke}, 0.2)
                end
            )
        end
        local function bi(bj, bk)
            local bl = false
            bj.InputBegan:Connect(
                function(bm)
                    if not aw(bm) then
                        return
                    end
                    bl = true
                    bh(bk)
                    task.delay(
                        0.4,
                        function()
                            while bl do
                                bh(bk)
                                task.wait(0.07)
                            end
                        end
                    )
                end
            )
            bj.InputEnded:Connect(
                function(bm)
                    if aw(bm) then
                        bl = false
                    end
                end
            )
            bj.MouseLeave:Connect(
                function()
                    bl = false
                end
            )
        end
        bi(a9, -1)
        bi(bb, 1)
        bg()
        task.defer(bc, true)
        return m(self, aU, bd, aV, 'Stepper')
    end
    function aS:Progress(aU)
        aU = l(
            aU, {Title = 'Name', Description = 'Desc', CurrentValue = 'Default', Value = 'Default'}
        )
        local aV = aM(self)
        local aW = aV.Compact
        local aX = aW and 6 or 10
        local aY, aZ = aO(self, 'Frame', (aU.Desc and aV.DescHeight or aV.Height) + aX, aU)
        aG(aY, aZ)
        local a_
        if aU.Desc then
            a_ = math.floor((aV.DescHeight - (aV.DescGap + aV.DescLine)) / 2) - 2
        else
            a_ = aW and 5 or 12
        end
        am(
            {
                Position = UDim2.fromOffset(14, a_), Size = UDim2.new(1, -110, 0, 18),
                Text = aU.Name or 'Progress', TextSize = aV.TextSize, Parent = aY
            }
        )
        if aU.Desc then
            am(
                {
                    Position = UDim2.fromOffset(14, a_ + aV.DescGap),
                    Size = UDim2.new(1, -110, 0, aV.DescLine), Text = aU.Desc,
                    TextSize = aV.DescSize, FontFace = D.Regular, TextColor3 = z.Muted, Parent = aY
                }
            )
        end
        local a0 = am(
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, a_),
                Size = UDim2.fromOffset(90, 18), TextXAlignment = Enum.TextXAlignment.Right,
                TextSize = 13, TextColor3 = k._color(aU.TextColor) or z.Accent, RichText = true,
                Parent = aY
            }
        )
        local a1 = ai(
            'Frame',
            {
                Position = UDim2.new(0, 14, 1, aW and -12 or -16), Size = UDim2.new(1, -28, 0, 5),
                BackgroundColor3 = z.Surface3, BorderSizePixel = 0, Parent = aY
            }
        )
        aj(a1, UDim.new(1, 0))
        local a2 = ai(
            'Frame',
            {
                Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = k._color(aU.Color) or z.Accent,
                BorderSizePixel = 0, Parent = a1
            }
        )
        aj(a2, UDim.new(1, 0))
        local a3 = {Value = math.clamp(aU.Default or 0, 0, 1)}
        local a4 = aU.Format
        local function a5(a6)
            local a7 = a3.Value
            ah(a2, {Size = UDim2.new(a7, 0, 1, 0)}, a6, Enum.EasingStyle.Quint)
            if type(a4) == 'function' then
                a0.Text = k._rich(a4(a7))
            else
                a0.Text = string.format('%d%%', math.floor(a7 * 100 + 0.5))
            end
        end
        function a3:Set(a6, a7)
            a6 = math.clamp(tonumber(a6) or 0, 0, 1)
            if a6 == a3.Value then
                return
            end
            a3.Value = a6
            a5(0.35)
            if not a7 then
                aJ(aU.Callback, a6)
            end
        end
        function a3:Get()
            return a3.Value
        end
        function a3:SetColor(a6)
            ah(a2, {BackgroundColor3 = k._color(a6) or z.Accent}, 0.25)
        end
        function a3:SetTextColor(a6)
            ah(a0, {TextColor3 = k._color(a6) or z.Accent}, 0.25)
        end
        ag(
            a0,
            function()
                a5(0)
            end
        )
        return m(self, aU, a3, aY, 'Progress')
    end
    function aS:OrderList(aU)
        aU = l(aU, {Title = 'Name', Description = 'Desc', Options = 'Items', Values = 'Items'})
        local aV = aM(self)
        local aW = aV.Compact
        local aX = self.Window
        local aY = E and 40 or 32
        local aZ = 4
        local a_ = aY + aZ
        local a0 = E and 34 or 26
        local a1 = E and 30 or 22
        local a2 = math.max(math.floor(tonumber(aU.MaxRows) or 6), 1)
        local a3 = aU.Numbered ~= false
        local a4 = aU.Arrows ~= false
        local a5 = aO(self, 'Frame', 0, aU)
        a5.AutomaticSize = Enum.AutomaticSize.Y
        if aW then
            al(a5, 14, 14, 6, 8)
        else
            al(a5, 14, 14, 11, 12)
        end
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = a5}
        )
        local a6 = tostring(aU.Name or '')
        am(
            {
                Size = UDim2.new(1, 0, 0, 18), Text = a6, TextSize = aV.TextSize,
                Visible = a6 ~= '', LayoutOrder = 1, Parent = a5
            }
        )
        if aU.Desc then
            am(
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    Text = aU.Desc, TextSize = aV.DescSize, FontFace = D.Regular,
                    TextColor3 = z.Muted, TextWrapped = true, TextTruncate = Enum.TextTruncate.None,
                    LayoutOrder = 2, Parent = a5
                }
            )
        end
        local a7 = ai(
            'ScrollingFrame',
            {
                Size = UDim2.new(1, 0, 0, aY + 2), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = E and 4 or 3, ScrollBarImageColor3 = z.Accent,
                ScrollBarImageTransparency = 0.4, ScrollingDirection = Enum.ScrollingDirection.Y,
                CanvasSize = UDim2.new(), ScrollingEnabled = false, LayoutOrder = 3, Parent = a5
            }
        )
        a7:SetAttribute('NoDrag', true)
        local a8 = ai(
            'Frame', {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = a7}
        )
        local a9 = am(
            {
                Size = UDim2.new(1, 0, 0, aY), Text = tostring(aU.EmptyText or 'Nothing to order'),
                TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Center, Visible = false, Parent = a8
            }
        )
        local function ba(bb, bc, bd, be, bf)
            bf.BackgroundTransparency = 1
            bf.Text = ''
            bf.AutoButtonColor = false
            bf.Parent = bb
            local bg = ai('TextButton', bf)
            local bh = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = E and UDim2.fromOffset(16, 16) or UDim2.fromOffset(14, 14),
                    BackgroundTransparency = 1, ImageColor3 = z.Muted,
                    ScaleType = Enum.ScaleType.Fit, Parent = bg
                }
            )
            aq(bh, bc)
            if bh.Image ~= '' then
                return bg, {Object = bh, Color = 'ImageColor3', Fade = 'ImageTransparency'}
            end
            bh:Destroy()
            local bi = am(
                {
                    Size = UDim2.fromScale(1, 1), Text = bd, TextSize = 18, TextColor3 = z.Muted,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextTruncate = Enum.TextTruncate.None, Rotation = be, Parent = bg
                }
            )
            return bg, {Object = bi, Color = 'TextColor3', Fade = 'TextTransparency'}
        end
        local function bb(bc, bd, be, bf)
            ah(bc.Object, {[bc.Color] = bd, [bc.Fade] = be}, bf)
        end
        local bc = {}
        local bd = {}
        local be = {}
        local bf = nil
        local bg, bh
        local function bi(bj)
            return 1 + (bj - 1) * a_
        end
        local function bj()
            local bk = {}
            for bl, bm in ipairs(bd) do
                bk[bl] = bm.Value
            end
            return bk
        end
        local function bk(bl)
            local bm = #bd
            for bn, bo in ipairs(bd) do
                bo.Index.Text = tostring(bn)
                if bo ~= bf then
                    ah(
                        bo.Frame, {Position = UDim2.fromOffset(3, bi(bn))}, bl and 0 or 0.22,
                        Enum.EasingStyle.Quint
                    )
                end
                if bo.UpIcon then
                    ah(
                        bo.UpIcon.Object, {[bo.UpIcon.Fade] = bn == 1 and 0.7 or 0},
                        bl and 0 or 0.15
                    )
                    ah(
                        bo.DownIcon.Object, {[bo.DownIcon.Fade] = bn == bm and 0.7 or 0},
                        bl and 0 or 0.15
                    )
                end
            end
        end
        local function bl()
            local bm = #bd
            local bn = math.max(bm, 1) * a_ - aZ + 2
            local bo = math.clamp(bm, 1, a2)
            local bp = bo * a_ - aZ + 2
            local bq = bm > a2
            a7.Size = UDim2.new(1, 0, 0, bp)
            a7.CanvasSize = UDim2.fromOffset(0, bn)
            a8.Size = UDim2.new(1, bq and -8 or 0, 0, bn)
            if not bf then
                a7.ScrollingEnabled = bq
            end
            a9.Visible = bm == 0
            local br = math.max(bn - bp, 0)
            if a7.CanvasPosition.Y > br then
                a7.CanvasPosition = Vector2.new(0, br)
            end
        end
        local function bm(bn)
            bc.Value = bj()
            if not bn then
                aJ(aU.Callback, bj())
            end
        end
        local function bn()
            if a7.ScrollingEnabled then
                return a7
            end
            return a5:FindFirstAncestorWhichIsA('ScrollingFrame')
        end
        local function bo(bp)
            local bq = ai(
                'Frame',
                {Size = UDim2.new(1, -6, 0, aY), BackgroundColor3 = z.Surface, BorderSizePixel = 0, Parent = a8}
            )
            aj(bq, UDim.new(0, 7))
            local br = {Value = bp, Frame = bq}
            br.Stroke = ak(bq)
            br.Scale = ai('UIScale', {Parent = bq})
            local bs
            bs, br.GripIcon = ba(bq, 'grip-vertical', '=', 0, {Size = UDim2.new(0, a0, 1, 0)})
            local bt = a0
            br.Index = am(
                {
                    Position = UDim2.fromOffset(bt, 0), Size = UDim2.new(0, 22, 1, 0),
                    TextSize = 12, TextColor3 = z.Accent, TextTruncate = Enum.TextTruncate.None,
                    Visible = a3, Parent = bq
                }
            )
            if a3 then
                bt += 22
            end
            local bu = a4 and a1 * 2 + 8 or 10
            br.Text = am(
                {
                    Position = UDim2.fromOffset(bt, 0), Size = UDim2.new(1, -(bt + bu), 1, 0),
                    Text = tostring(bp), TextSize = 13, Parent = bq
                }
            )
            local bv = {}
            if a4 then
                local bw, bx
                bw, br.UpIcon = ba(
                    bq, 'chevron-up', '\u{203a}', -90,
                    {
                        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -(a1 + 6), 0, 0),
                        Size = UDim2.new(0, a1, 1, 0)
                    }
                )
                bx, br.DownIcon = ba(
                    bq, 'chevron-down', '\u{203a}', 90,
                    {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 0), Size = UDim2.new(
                        0, a1, 1, 0
                    )}
                )
                for by, bz in pairs({[bw] = -1, [bx] = 1}) do
                    local bA = bz < 0 and br.UpIcon or br.DownIcon
                    local bB = ay(by, bn)
                    by.MouseEnter:Connect(
                        function()
                            if not ax() then
                                ah(bA.Object, {[bA.Color] = z.Accent}, 0.12)
                            end
                        end
                    )
                    by.MouseLeave:Connect(
                        function()
                            ah(bA.Object, {[bA.Color] = z.Muted}, 0.2)
                        end
                    )
                    by.MouseButton1Click:Connect(
                        function()
                            if bB() then
                                bg(br, bz)
                            end
                        end
                    )
                    table.insert(bv, by)
                end
            end
            bs.InputBegan:Connect(
                function(bw)
                    if aw(bw) then
                        bh(br)
                    end
                end
            )
            bq.InputBegan:Connect(
                function(bw)
                    if bw.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end
                    local bx = av()
                    for by, bz in ipairs(bv) do
                        if az(bx, bz) then
                            return
                        end
                    end
                    bh(br)
                end
            )
            bq.MouseEnter:Connect(
                function()
                    if not ax() and br ~= bf then
                        ah(br.Stroke, {Color = z.StrokeHover}, 0.12)
                        bb(br.GripIcon, z.Text, 0, 0.12)
                    end
                end
            )
            bq.MouseLeave:Connect(
                function()
                    if br ~= bf then
                        ah(br.Stroke, {Color = z.Stroke}, 0.25)
                        bb(br.GripIcon, z.Muted, 0, 0.25)
                    end
                end
            )
            return br
        end
        local function bp(bq)
            local br = {}
            for bs, bt in ipairs(bd) do
                br[bt.Value] = br[bt.Value] or {}
                table.insert(br[bt.Value], bt)
            end
            local bs = {}
            for bt, bu in ipairs(bq) do
                local bv = br[bu]
                local bw = bv and table.remove(bv, 1)
                if not bw then
                    bw = bo(bu)
                    bw.Frame.Position = UDim2.fromOffset(3, bi(bt))
                end
                bs[bt] = bw
            end
            for bt, bu in pairs(br) do
                for bv, bw in ipairs(bu) do
                    bw.Frame:Destroy()
                end
            end
            bd = bs
        end
        local function bq(br, bs)
            local bt = {}
            for bu, bv in ipairs(br) do
                bt[bv] = (bt[bv] or 0) + 1
            end
            local bu = {}
            for bv, bw in ipairs({bs, br}) do
                for bx, by in ipairs(bw) do
                    if (bt[by] or 0) > 0 then
                        bt[by] -= 1
                        table.insert(bu, by)
                    end
                end
            end
            return bu
        end
        local function br(bs)
            local bt = bi(bs) - 1
            local bu = a7.AbsoluteWindowSize.Y / aX.Scale.Scale
            local bv = a7.CanvasPosition.Y
            if bt < bv then
                bv = bt
            elseif bt + aY + 2 > bv + bu then
                bv = bt + aY + 2 - bu
            end
            if bv ~= a7.CanvasPosition.Y then
                ah(a7, {CanvasPosition = Vector2.new(0, math.max(bv, 0))}, 0.2)
            end
        end
        function bg(bs, bt)
            if bf then
                return
            end
            local bu = table.find(bd, bs)
            local bv = bu and bu + bt
            if not bv or bv < 1 or bv > #bd then
                return
            end
            bd[bu], bd[bv] = bd[bv], bd[bu]
            bk(false)
            ah(bs.Stroke, {Color = z.Accent}, 0.08)
            task.delay(
                0.18,
                function()
                    if bs ~= bf then
                        ah(bs.Stroke, {Color = z.Stroke}, 0.3)
                    end
                end
            )
            br(bv)
            bm(false)
        end
        local bs, bt = 0, nil
        local bu, bv, bw = nil, nil, nil
        local function bx(by)
            local bz = aX.Scale.Scale
            local bA = (by.Y - bs - a7.AbsolutePosition.Y) / bz + a7.CanvasPosition.Y
            bA = math.clamp(bA, bi(1), bi(#bd))
            bf.Frame.Position = UDim2.fromOffset(3, bA)
            local bB = math.clamp(math.floor((bA - 1) / a_ + 0.5) + 1, 1, #bd)
            local bC = table.find(bd, bf)
            if bC ~= bB then
                table.remove(bd, bC)
                table.insert(bd, bB, bf)
                bk(false)
            end
        end
        local function by(bz)
            if not bf or not bt then
                return
            end
            local bA = aX.Scale.Scale
            local bB = a7.AbsolutePosition.Y
            local bC = bB + a7.AbsoluteSize.Y
            local bD = aY * bA
            local bE = 0
            if bt.Y < bB + bD then
                bE = -(bB + bD - bt.Y) / bD
            elseif bt.Y > bC - bD then
                bE = (bt.Y - (bC - bD)) / bD
            end
            if bE == 0 then
                return
            end
            local bF = math.max(a7.CanvasSize.Y.Offset - a7.AbsoluteWindowSize.Y / bA, 0)
            local bG = math.clamp(a7.CanvasPosition.Y + math.clamp(bE, -1.5, 1.5) * 360 * bz, 0, bF)
            if bG ~= a7.CanvasPosition.Y then
                a7.CanvasPosition = Vector2.new(0, bG)
                bx(bt)
            end
        end
        function bh(bz)
            if bf or #bd < 2 or bc._destroyed then
                return
            end
            bf = bz
            bu = table.clone(bd)
            bt = av()
            bs = bt.Y - bz.Frame.AbsolutePosition.Y
            bz.Frame.ZIndex = 5
            ah(bz.Frame, {BackgroundColor3 = z.Surface3}, 0.12)
            ah(bz.Stroke, {Color = z.Accent}, 0.12)
            ah(bz.Scale, {Scale = 1.02}, 0.18, Enum.EasingStyle.Back)
            bb(bz.GripIcon, z.Accent, 0, 0.12)
            a7.ScrollingEnabled = false
            local bA = a5:FindFirstAncestorWhichIsA('ScrollingFrame')
            if bA and bA.ScrollingEnabled then
                bw = bA
                bA.ScrollingEnabled = false
            end
            bv = aX:_listen('Render', by)
        end
        local function bz(bA)
            local bB = bf
            if not bB then
                return
            end
            bf = nil
            bt = nil
            if bv then
                bv()
                bv = nil
            end
            if bw then
                bw.ScrollingEnabled = true
                bw = nil
            end
            ah(bB.Frame, {BackgroundColor3 = z.Surface}, 0.2)
            ah(bB.Stroke, {Color = z.Stroke}, 0.25)
            ah(bB.Scale, {Scale = 1}, 0.2)
            bb(bB.GripIcon, z.Muted, 0, 0.25)
            task.delay(
                0.22,
                function()
                    if bB ~= bf then
                        bB.Frame.ZIndex = 1
                    end
                end
            )
            bk(false)
            bl()
            for bC, bD in ipairs(bd) do
                if bu[bC] ~= bD then
                    bm(bA)
                    break
                end
            end
        end
        aX:_listen(
            'Changed',
            function(bA)
                if bf and aA(bA) then
                    bt = av()
                    bx(bt)
                end
            end, bc
        )
        aX:_listen(
            'Ended',
            function(bA)
                if bf and aw(bA) then
                    bz(false)
                end
            end, bc
        )
        table.insert(
            bc._listeners,
            function()
                bz(true)
            end
        )
        bc._onHide = function()
            bz(false)
        end
        function bc:Set(bA, bB)
            if type(bA) ~= 'table' then
                return
            end
            bz(true)
            be = table.clone(bA)
            bp(bq(bj(), be))
            bk(false)
            bl()
            bm(bB)
        end
        function bc:Get()
            return bj()
        end
        function bc:Refresh(bA, bB, bC)
            bz(true)
            bA = type(bA) == 'table' and table.clone(bA) or {}
            if bB ~= false then
                bA = bq(bA, bc:_saveValue())
            else
                be = {}
            end
            bp(bA)
            bk(false)
            bl()
            bm(bC)
        end
        function bc:_saveValue()
            local bA = bj()
            local bB = {}
            for bC, bD in ipairs(bA) do
                bB[bD] = (bB[bD] or 0) + 1
            end
            for bC, bD in ipairs(be) do
                if (bB[bD] or 0) > 0 then
                    bB[bD] -= 1
                else
                    table.insert(bA, bD)
                end
            end
            return bA
        end
        bp(type(aU.Items) == 'table' and aU.Items or {})
        bk(true)
        bl()
        bc.Value = bj()
        return m(self, aU, bc, a5, 'OrderList')
    end
    for aU, aV in pairs(table.clone(aS)) do
        if type(aV) == 'function' and aU:sub(1, 1) ~= '_' and aU:sub(1, 6) ~= 'Create' then
            aS['Create' .. aU] = aV
        end
    end
    local function aU()
        local aV
        pcall(
            function()
                if typeof(identifyexecutor) == 'function' then
                    aV = (identifyexecutor())
                elseif typeof(getexecutorname) == 'function' then
                    aV = getexecutorname()
                end
            end
        )
        if type(aV) == 'string' and #aV > 0 then
            return aV
        end
        return d:IsStudio() and 'Studio' or 'Unknown'
    end
    local function aV(aW)
        local aX = aU()
        local aY = aW.SupportedExecutors
        if type(aY) == 'table' then
            local aZ = string.lower(aX)
            for a_, a0 in ipairs(aY) do
                if string.find(aZ, string.lower(tostring(a0)), 1, true) then
                    return aX, true, 'Your executor is supported and fully compatible.'
                end
            end
            return aX, false, 'Not on the supported list. Some features may not work.'
        end
        local aZ = {
            {'writefile', writefile}, {'readfile', readfile}, {'getcustomasset', getcustomasset},
            {'setclipboard', setclipboard or toclipboard},
            {'request', request or http_request or (syn and syn.request)}
        }
        local a_ = {}
        for a0, a1 in ipairs(aZ) do
            if type(a1[2]) ~= 'function' then
                table.insert(a_, a1[1])
            end
        end
        if #a_ == 0 then
            return aX, true, 'Your executor is supported and fully compatible.'
        end
        return aX, false, 'Missing ' .. table.concat(a_, ', ') .. '. Some features may not work.'
    end
    local aW = {}
    function aW.Path(aX)
        return tostring(aX) .. '/unsupported_skip.txt'
    end
    function aW.Available()
        return type(writefile) == 'function' and type(readfile) == 'function' and type(isfile) == 'function'
    end
    function aW.Saved(aX, aY)
        if not aW.Available() then
            return false
        end
        local aZ = aW.Path(aX)
        local a_, a0 = pcall(
            function()
                return isfile(aZ) and readfile(aZ) or nil
            end
        )
        return a_ and a0 == aY
    end
    function aW.Write(aX, aY, aZ)
        if not aW.Available() then
            return false
        end
        return pcall(
            function()
                if type(isfolder) == 'function' and type(makefolder) == 'function' then
                    local a_ = ''
                    for a0 in tostring(aX):gmatch('[^/\\]+') do
                        a_ = a_ == '' and a0 or a_ .. '/' .. a0
                        if not isfolder(a_) then
                            makefolder(a_)
                        end
                    end
                end
                writefile(aY, aZ)
            end
        )
    end
    function aW.Save(aX, aY)
        return aW.Write(aX, aW.Path(aX), aY)
    end
    function aW.DisclaimerKey(aX)
        if aX.Id ~= nil then
            return (tostring(aX.Id):gsub('[\r\n]', ' '))
        end
        local aY = tostring(aX.Title) .. '\0' .. tostring(aX.Text)
        local aZ = 5381
        for a_ = 1, #aY do
            aZ = (aZ * 33 + aY:byte(a_)) % 4294967296
        end
        return string.format('%08x', aZ)
    end
    function aW.DisclaimerAccepted(aX, aY)
        if not aW.Available() then
            return false
        end
        local aZ = tostring(aX) .. '/disclaimers.txt'
        local a_, a0 = pcall(
            function()
                return isfile(aZ) and readfile(aZ) or ''
            end
        )
        if not a_ or type(a0) ~= 'string' then
            return false
        end
        for a1 in a0:gmatch('[^\r\n]+') do
            if a1 == aY then
                return true
            end
        end
        return false
    end
    function aW.AcceptDisclaimer(aX, aY)
        if aW.DisclaimerAccepted(aX, aY) then
            return true
        end
        local aZ = tostring(aX) .. '/disclaimers.txt'
        local a_, a0 = pcall(
            function()
                return isfile(aZ) and readfile(aZ) or ''
            end
        )
        a0 = a_ and type(a0) == 'string' and a0 or ''
        if a0 ~= '' and not a0:match('\n$') then
            a0 ..= '\n'
        end
        return aW.Write(aX, aZ, a0 .. aY .. '\n')
    end
    local aX = nil
    local function aY()
        if aX == nil then
            local aZ, a_ = pcall(
                function()
                    return h:GetProductInfo(game.PlaceId)
                end
            )
            aX = aZ and type(a_) == 'table' and a_ or false
        end
        return aX or nil
    end
    local function aZ()
        local a_ = aY()
        if a_ and a_.Name then
            return a_.Name
        end
        return d:IsStudio() and 'Studio' or 'Unknown game'
    end
    local a_ = {
        US = 'United States', GB = 'United Kingdom', DE = 'Germany', FR = 'France',
        NL = 'Netherlands', SG = 'Singapore', JP = 'Japan', AU = 'Australia', BR = 'Brazil',
        IN = 'India', HK = 'Hong Kong', CA = 'Canada'
    }
    local function a0(a1)
        task.spawn(
            function()
                local a2 = request or http_request or (syn and syn.request) or (http and http.request)
                local a3
                if type(a2) == 'function' then
                    pcall(
                        function()
                            local a4 = a2({Url = 'https://ipinfo.io/json', Method = 'GET'})
                            local a5 = type(a4) == 'table' and (a4.Body or a4.body) or nil
                            if type(a5) == 'string' then
                                local a6 = e:JSONDecode(a5)
                                if type(a6) == 'table' and a6.country then
                                    local a7 = a_[a6.country] or a6.country
                                    a3 = a6.city and (a6.city .. ', ' .. a7) or a7
                                end
                            end
                        end
                    )
                end
                a1(a3 or 'Unavailable')
            end
        )
    end
    local a1 = setmetatable(
        {},
        {
            __index = function(a1, a2)
                if a2 == 'Success' or a2 == 'Warning' or a2 == 'Error' then
                    return z[a2]
                end
                return nil
            end
        }
    )
    local a2 = {}
    a2.__index = a2
    function k.Window(a3, a4)
        a4 = l(a4, {Name = 'Title', LoadingSubtitle = 'Subtitle', ToggleUIKeybind = 'Keybind'})
        if type(a4.Keybind) == 'string' then
            a4.Keybind = Enum.KeyCode[a4.Keybind]
        end
        local a5 = a4.Size or UDim2.fromOffset(760, 520)
        local a6 = a4.Keybind or Enum.KeyCode.RightControl
        local a7 = setmetatable(
            {
                Tabs = {}, CurrentTab = nil, Open = true, Keybind = a6, _connections = {},
                _controls = {},
                _inputListeners = {Began = {}, Changed = {}, Ended = {}, Render = {}},
                _frameSteps = {}, _destroyed = false, _identity = {Names = {}, Avatars = {}},
                _pinned = {}, Minimized = false, _hideName = false, _hideAvatar = false,
                Title = a4.Title or 'Airflow', _logoIcon = a4.Icon or A.Logo,
                _sessionStart = os.clock(), _islandLocked = a4.IslandDraggable == false
            }, a2
        )
        local a8 = type(a4.ConfigurationSaving) == 'table' and a4.ConfigurationSaving or {}
        a7.ConfigFolder = a8.FolderName or 'AirflowUI'
        a7.ConfigName = a8.FileName
        a7._configListeners = {}
        a7._pendingFlags = {}
        local a9 = a4.DefaultTheme or a4.Theme
        if a9 ~= nil then
            k.DefaultTheme = a9
        end
        a7:_applyDefaultTheme()
        a7._uiScale = math.clamp(tonumber(a4.UIScale) or 1, 0.6, 1.5)
        a7._adaptive = a4.AdaptiveSize ~= false
        a7.UIScale = a7._uiScale
        if a4.Density ~= nil then
            k:SetDensity(a4.Density)
        end
        if a4.CornerRadius ~= nil then
            k:SetCornerRadius(a4.CornerRadius, true)
        end
        local function ba(bb)
            return function(...)
                for bc, bd in ipairs(a7._inputListeners[bb]) do
                    bd(...)
                end
            end
        end
        local bb = ba('Render')
        table.insert(
            a7._connections,
            d.RenderStepped:Connect(
                function(bc)
                    bb(bc)
                    for bd, be in ipairs(a7._frameSteps) do
                        be(bc)
                    end
                end
            )
        )
        table.insert(a7._connections, b.InputBegan:Connect(ba('Began')))
        table.insert(a7._connections, b.InputChanged:Connect(ba('Changed')))
        table.insert(a7._connections, b.InputEnded:Connect(ba('Ended')))
        local bc = ai(
            'ScreenGui',
            {
                Name = a4.Name or 'AirflowUI', IgnoreGuiInset = true, ResetOnSpawn = false,
                DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            }
        )
        a7.Gui = bc
        local bd = ai(
            'Frame',
            {
                Name = 'Window', AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5), Size = a5, BackgroundTransparency = 1,
                Parent = bc
            }
        )
        a7.Root = bd
        local be = ai('UIScale', {Parent = bd})
        a7.Scale = be
        local bf = ai(
            'ImageLabel',
            {
                Position = UDim2.fromOffset(-25, -25), Size = UDim2.new(1, 50, 1, 50),
                BackgroundTransparency = 1, Image = A.Shadow, ImageColor3 = Color3.new(0, 0, 0),
                ImageTransparency = 0.6, ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450), Parent = bd
            }
        )
        a7.Shadow = bf
        a7._shadowRest = 0.6
        local bg = ai(
            'CanvasGroup',
            {
                Name = 'Fader', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                GroupTransparency = 1, ZIndex = 2, Parent = bd
            }
        )
        a7._fader = bg
        a7._bodyAlpha = 1
        local bh = ai(
            'Frame',
            {
                Name = 'Body', Size = UDim2.fromScale(1, 1), BackgroundColor3 = z.Background,
                BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2, Parent = bg
            }
        )
        a7.Body = bh
        aj(bh, UDim.new(0, 10))
        a7.BodyStroke = ak(bh, z.Stroke)
        ao(bh)
        a7._backgroundImage = ai(
            'ImageLabel',
            {
                Name = 'BackgroundImage', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                ScaleType = Enum.ScaleType.Crop, ImageTransparency = 1, Visible = false, ZIndex = 0,
                Parent = bh
            }
        )
        aj(a7._backgroundImage, UDim.new(0, 10))
        a7.BackgroundTransparency = math.clamp(tonumber(a4.BackgroundTransparency) or 0.35, 0, 1)
        a7._backgroundGeneration = 0
        local bi = ai(
            'Frame',
            {
                Name = 'Sidebar', Size = UDim2.new(0, F, 1, 0), BackgroundTransparency = 1,
                BorderSizePixel = 0, ClipsDescendants = true, Parent = bh
            }
        )
        a7.Sidebar = bi
        local bj = ai(
            'Frame',
            {
                Name = 'Fill', Size = UDim2.new(1, 24, 1, 0), BackgroundColor3 = z.Surface,
                BorderSizePixel = 0, ZIndex = 0, Parent = bi
            }
        )
        aj(bj, UDim.new(0, 10))
        a7.SidebarFill = bj
        ai(
            'Frame',
            {
                Name = 'Divider', AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                ZIndex = 2, Parent = bi
            }
        )
        local bk = ai(
            'Frame',
            {Name = 'Header', Size = UDim2.new(1, 0, 0, G), BackgroundTransparency = 1, Parent = bi}
        )
        local bl = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
                Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1, Image = '',
                ImageColor3 = z.Accent, ScaleType = Enum.ScaleType.Fit, Parent = bk
            }
        )
        aq(bl, a4.Icon or A.Logo, true)
        local bm = a4.Version or a4.Subtitle
        am(
            {
                Position = UDim2.new(0, 56, 0.5, bm and -15 or -9), Size = UDim2.new(1, -68, 0, 18),
                Text = a7.Title, TextSize = 14, FontFace = D.Bold, Parent = bk
            }
        )
        if bm then
            am(
                {
                    Position = UDim2.new(0, 56, 0.5, 3), Size = UDim2.new(1, -68, 0, 14),
                    Text = tostring(bm), TextSize = 11, FontFace = D.Regular, TextColor3 = z.Muted,
                    Parent = bk
                }
            )
        end
        local bn = a4.Profile ~= false
        local bo = ai(
            'ScrollingFrame',
            {
                Name = 'Tabs', Position = UDim2.fromOffset(0, G),
                Size = UDim2.new(1, 0, 1, -(G + (bn and M + 4 or 12))), BackgroundTransparency = 1,
                BorderSizePixel = 0, ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = bi
            }
        )
        a7.TabList = bo
        local bp = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(8, 2), Size = UDim2.new(1, -16, 0, H),
                BackgroundColor3 = z.Surface3, BackgroundTransparency = 0.35, BorderSizePixel = 0,
                Visible = false, Parent = bo
            }
        )
        aj(bp, UDim.new(0, 7))
        local bq = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(2, 14), BackgroundColor3 = z.Accent, Visible = false,
                BorderSizePixel = 0, Parent = bp
            }
        )
        aj(bq, UDim.new(1, 0))
        a7._indicatorPill = bq
        a7.Indicator = bp
        local br = ai(
            'Frame',
            {
                Name = 'Stack', Position = UDim2.fromOffset(8, 2), Size = UDim2.new(1, -16, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 2,
                Parent = bo
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = br}
        )
        a7._tabStack = br
        a7:_overflowHint(bi, bo, br, true, z.Surface)
        if bn then
            a7:_buildProfile(bi)
        end
        local bs = ai(
            'Frame',
            {
                Name = 'Content', Position = UDim2.fromOffset(F + 1, 0),
                Size = UDim2.new(1, -(F + 1), 1, 0), BackgroundTransparency = 1,
                ClipsDescendants = true, Parent = bh
            }
        )
        a7.Content = bs
        a7:_sidebarResize(bi, tonumber(a4.SidebarWidth) or F)
        a7._outLayer = ai(
            'CanvasGroup',
            {
                Name = 'TransitionOut', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Visible = false, ZIndex = 2, Parent = bs
            }
        )
        a7._inLayer = ai(
            'CanvasGroup',
            {
                Name = 'TransitionIn', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Visible = false, ZIndex = 3, Parent = bs
            }
        )
        local bt = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 14),
                Size = UDim2.fromOffset(34, 34), BackgroundColor3 = z.Surface2,
                BackgroundTransparency = 1, Text = '', AutoButtonColor = false, ZIndex = 5,
                Parent = bs
            }
        )
        bt:SetAttribute('NoDrag', true)
        local bu = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ScaleType = Enum.ScaleType.Fit, Parent = bt
            }
        )
        aq(bu, 'minimize-2')
        bt.MouseEnter:Connect(
            function()
                ah(
                    bu, {ImageColor3 = z.Text, Size = UDim2.fromOffset(18, 18)}, 0.2,
                    Enum.EasingStyle.Quint
                )
            end
        )
        bt.MouseLeave:Connect(
            function()
                ah(
                    bu, {ImageColor3 = z.Muted, Size = UDim2.fromOffset(20, 20)}, 0.25,
                    Enum.EasingStyle.Quint
                )
            end
        )
        bt.MouseButton1Click:Connect(
            function()
                a7:Minimize()
            end
        )
        a7.MinimizeButton = bt
        if a4.Search ~= false then
            a7:_buildSearch(bs)
        end
        local bv = ai(
            'Frame',
            {
                Name = 'Notifications', AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, -20, 1, -20), Size = UDim2.new(0, 280, 1, -40),
                BackgroundTransparency = 1, Parent = bc
            }
        )
        local function bw()
            bv.Size = UDim2.new(0, math.min(280, bc.AbsoluteSize.X - 40), 1, -40)
        end
        table.insert(a7._connections, bc:GetPropertyChangedSignal('AbsoluteSize'):Connect(bw))
        ai(
            'UIListLayout',
            {
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 4),
                Parent = bv
            }
        )
        a7.NotifyHolder = bv
        a7._notifyOrder = 0
        a7._toasts = {}
        a7.MaxNotifications = a4.MaxNotifications or 4
        a7._controlsDirty = true
        table.insert(
            a7._connections,
            bh.DescendantAdded:Connect(
                function()
                    a7._controlsDirty = true
                end
            )
        )
        table.insert(
            a7._connections,
            bh.DescendantRemoving:Connect(
                function()
                    a7._controlsDirty = true
                end
            )
        )
        a7:SetDragStyle(a4.DragStyle or (a4.DragSkeleton == false and 'Off' or 'Outline'))
        a7:SetIslandStyle(a4.IslandStyle)
        if a4.Transparent then
            a7:SetTransparent(true)
        end
        if a4.Background then
            task.spawn(a7.SetBackground, a7, a4.Background)
        end
        a7:_enableDrag()
        a7.MaxSize = a4.MaxSize
        a7.KeepOnScreen = a4.KeepOnScreen ~= false
        a7:_enableResize(a4.MinSize or Vector2.new(480, 360))
        if a4.SaveSize ~= false then
            local bx = a7
            local by = {_type = 'WindowSize', _listeners = {}}
            function by:Get()
                local bz = bx:GetSize()
                return {Width = bz.X, Height = bz.Y}
            end
            function by:Set(bz)
                if type(bz) == 'table' and tonumber(bz.Width) and tonumber(bz.Height) then
                    bx:SetSize(Vector2.new(tonumber(bz.Width), tonumber(bz.Height)))
                end
            end
            local bz = type(a4.SaveSize) == 'string' and a4.SaveSize or '__WindowSize'
            k.Flags[bz] = by
            a7:_flagCreated(bz, by)
        end
        table.insert(
            a7._connections,
            b.InputBegan:Connect(
                function(bx, by)
                    if by then
                        return
                    end
                    if bx.UserInputType == Enum.UserInputType.Keyboard and bx.KeyCode == a7.Keybind then
                        task.defer(
                            function()
                                local bz = a7._consumedKey == bx.KeyCode and os.clock() - (a7._consumedAt or 0) < 0.2
                                a7._consumedKey = nil
                                if not bz and not a7._destroyed then
                                    if a7.Minimized then
                                        a7:Restore()
                                    else
                                        a7:Toggle(not a7.Open)
                                    end
                                end
                            end
                        )
                    end
                end
            )
        )
        pcall(
            function()
                if typeof(syn) == 'table' and typeof(syn.protect_gui) == 'function' then
                    syn.protect_gui(bc)
                end
            end
        )
        bc.Parent = a4.Parent or as()
        be.Scale = 0.9
        bf.ImageTransparency = 1
        a7.BodyStroke.Transparency = 1
        bd.Visible = false
        a7:_fitToScreen(true)
        table.insert(
            a7._connections,
            bc:GetPropertyChangedSignal('AbsoluteSize'):Connect(
                function()
                    a7:_fitToScreen()
                    a7:_clampToScreen()
                end
            )
        )
        local bx = a4.ToggleButton
        if bx == nil or bx == true then
            bx = {}
        end
        if type(bx) == 'table' then
            a7:_createToggleButton(bx)
        end
        local by = a7.ToggleButton ~= nil and a7:_toggleButtonAllowed()
        if (a4.OpenButton ~= nil and a4.OpenButton ~= false) or (a4.OpenButton == nil and E and not by) then
            a7:_createOpenButton(type(a4.OpenButton) == 'table' and a4.OpenButton or {})
        end
        if a4.Backdrop ~= false then
            a7:_buildBackdrop(type(a4.Backdrop) == 'table' and a4.Backdrop or {})
        end
        a7._introDone = false
        table.insert(k.Windows, a7)
        if a4.Home ~= false then
            a7:_buildHome(type(a4.Home) == 'table' and a4.Home or {})
        end
        local bz = a4.Loading
        if type(bz) == 'table' then
            a4.LoadingDuration = bz.Duration or a4.LoadingDuration
            a4.LoadingText = bz.Text or bz.Subtitle or a4.LoadingText
            a4.LoadingSteps = bz.Steps or a4.LoadingSteps
            a4.LoadingTitle = bz.Title or a4.LoadingTitle
            bz = bz.Enabled ~= false
        end
        local bA = {}
        local bB = a4.UnsupportedExecutor
        if bB ~= false then
            bB = type(bB) == 'table' and bB or {}
            local bC = a4.SupportedExecutors or (type(a4.Home) == 'table' and a4.Home.SupportedExecutors or nil)
            local bD, bE, bF = aV({SupportedExecutors = bC})
            if not bE and not aW.Saved(a7.ConfigFolder, bD) then
                local bG = bB.Block == true
                local bH = a7.ConfigFolder
                table.insert(
                    bA,
                    {
                        Title = bB.Title or 'Unsupported executor', Subtitle = bD,
                        Text = bG and ((bB.Text or bF) .. " This script can't run here.") or (bB.Text or bF),
                        Icon = 'shield-alert', Color = z.Warning, ContinueText = 'Continue anyway',
                        ExitText = 'Exit', Block = bG,
                        RememberText = "Don't ask again on this executor",
                        Remember = function()
                            aW.Save(bH, bD)
                        end
                    }
                )
            end
        end
        local bC = a4.Disclaimer or a4.Disclaimers
        if type(bC) == 'string' or (type(bC) == 'table' and (bC.Title ~= nil or bC.Text ~= nil)) then
            bC = {bC}
        end
        if type(bC) == 'table' then
            for bD, bE in ipairs(bC) do
                if type(bE) == 'string' then
                    bE = {Text = bE}
                end
                if type(bE) == 'table' then
                    local bF = aW.DisclaimerKey(bE)
                    local bG = a7.ConfigFolder
                    local bH = bE.Block == true
                    local bI = bE.Remember ~= false and not bH
                    if not (bI and aW.DisclaimerAccepted(bG, bF)) then
                        local bJ = bE.Callback
                        table.insert(
                            bA,
                            {
                                Title = bE.Title or 'Disclaimer', Subtitle = bE.Subtitle,
                                Text = bE.Text or '', Icon = bE.Icon or 'info',
                                Color = bE.Color or z.Accent,
                                ContinueText = bE.AcceptText or 'I understand',
                                ExitText = bE.DeclineText == nil and 'Exit' or bE.DeclineText,
                                RememberText = bI and (bE.RememberText or "Don't show again") or nil,
                                Remember = function()
                                    aW.AcceptDisclaimer(bG, bF)
                                end, Callback = type(bJ) == 'function' and bJ or nil, Block = bH
                            }
                        )
                    end
                end
            end
        end
        if #bA > 0 then
            a4._prompts = bA
        end
        if bz == false and a4._prompts then
            a4.LoadingDuration = a4.LoadingDuration or 0.5
            bz = true
        end
        if bz == false then
            task.defer(
                function()
                    a7:_playIntro()
                end
            )
        else
            a7:_showLoader(a4)
        end
        return a7
    end
    k.CreateWindow = k.Window
    function k:Notify(a3)
        local a4 = k.Windows[#k.Windows]
        if a4 then
            return a4:Notify(a3)
        end
    end
    function k:Confirm(a3)
        local a4 = k.Windows[#k.Windows]
        if a4 then
            return a4:Confirm(a3)
        end
    end
    function k:Dialog(a3)
        local a4 = k.Windows[#k.Windows]
        if a4 then
            return a4:Dialog(a3)
        end
    end
    local function a3(a4, a5, a6)
        local a7 = a4
        while a7 and a7 ~= a5 and a7:IsA('GuiObject') do
            if not a7.Visible then
                return false
            end
            local a8 = a7.Parent
            if a8 and a8 ~= a5 and a8:IsA('GuiObject') and (a8.ClipsDescendants or a8:IsA(
                'ScrollingFrame'
            )) and not az(a6, a8) then
                return false
            end
            a7 = a8
        end
        return true
    end
    function a2:_refreshControls()
        local a4 = {}
        for a5, a6 in ipairs(self.Body:GetDescendants()) do
            if a6:IsA('GuiButton') or a6:IsA('TextBox') or a6:GetAttribute('NoDrag') then
                table.insert(a4, a6)
            end
        end
        self._controls = a4
        self._controlsDirty = false
    end
    function a2:_overControl(a4)
        if self._dialog or self:_overPopout(a4) then
            return true
        end
        if self._controlsDirty then
            self:_refreshControls()
        end
        for a5, a6 in ipairs(self._controls) do
            if a6.Parent and az(a4, a6) and a3(a6, self.Body, a4) then
                return true
            end
        end
        return false
    end
    function a2:_tooltipCard()
        if self._tip then
            return self._tip
        end
        local a4 = ai(
            'CanvasGroup',
            {
                Name = 'Tooltip', Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1,
                GroupTransparency = 1, Visible = false, ZIndex = 60, Parent = self.Gui
            }
        )
        local a5 = ai('UIScale', {Parent = a4})
        local a6 = 4
        local a7 = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(a6, a6), Size = UDim2.fromOffset(0, 0),
                AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Parent = a4
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = a7}
        )
        local function a8(a9)
            ai(
                'UIStroke',
                {
                    Color = Color3.new(0, 0, 0), Transparency = 0.35, Thickness = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Parent = a9
                }
            )
        end
        local a9 = ai(
            'Frame',
            {
                Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, LayoutOrder = 1, Parent = a7
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = a9
            }
        )
        local ba = ai(
            'ImageLabel',
            {
                Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = z.Accent,
                ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1, Parent = a9
            }
        )
        local bb = am(
            {
                Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, TextSize = 13,
                FontFace = D.Bold, TextTruncate = Enum.TextTruncate.None, LayoutOrder = 2,
                Parent = a9
            }
        )
        a8(bb)
        local bc = am(
            {
                Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, TextSize = 12,
                FontFace = D.Medium, TextWrapped = true, TextTruncate = Enum.TextTruncate.None,
                TextYAlignment = Enum.TextYAlignment.Top, LineHeight = 1.1, LayoutOrder = 2,
                Parent = a7
            }
        )
        a8(bc)
        ai('UISizeConstraint', {MaxSize = Vector2.new(240, math.huge), Parent = bc})
        local function bd()
            local be = math.max(a5.Scale, 0.01)
            local bf = a7.AbsoluteSize / be
            a4.Size = UDim2.fromOffset(bf.X + a6 * 2, bf.Y + a6 * 2)
        end
        a7:GetPropertyChangedSignal('AbsoluteSize'):Connect(bd)
        local be = {
            Holder = a4, Scale = a5, Pad = a6, Head = a9, Icon = ba, Title = bb, Body = bc,
            Shown = false, Fit = bd
        }
        self._tip = be
        self:_listen(
            'Render',
            function(bf)
                local bg = self._tipOwner
                if not bg then
                    return
                end
                local bh = bg._frame
                if bg._destroyed or not self.Open or self.Minimized or not bh or not bh.Parent or (bg._isShown and not bg:_isShown(
                )) or not a3(bh, self.Body, bh.AbsolutePosition + bh.AbsoluteSize / 2) then
                    self:_hideTooltip()
                    return
                end
                local bi = av() - self.Gui.AbsolutePosition
                local bj = be.Pad * a5.Scale
                local bk = a4.AbsoluteSize - Vector2.one * bj * 2
                local bl = self.Gui.AbsoluteSize
                local bm, bn
                if be.Touch then
                    bm, bn = bi.X - bk.X / 2, bi.Y - bk.Y - 30
                else
                    bm, bn = bi.X + 14, bi.Y + 20
                    if bm + bk.X > bl.X - 8 then
                        bm = bi.X - bk.X - 10
                    end
                    if bn + bk.Y > bl.Y - 8 then
                        bn = bi.Y - bk.Y - 12
                    end
                end
                local bo = Vector2.new(
                    math.clamp(bm, 8, math.max(8, bl.X - bk.X - 8)),
                    math.clamp(bn, 8, math.max(8, bl.Y - bk.Y - 8))
                )
                local bp = be.Position
                if not bp or be.Snap then
                    bp = bo + Vector2.new(0, 6)
                    be.Snap = false
                else
                    bp = bp:Lerp(bo, math.min(bf * 22, 1))
                end
                be.Position = bp
                a4.Position = UDim2.fromOffset(
                    math.floor(bp.X - bj + 0.5), math.floor(bp.Y - bj + 0.5)
                )
            end
        )
        self:_listen(
            'Began',
            function(bf)
                if self._tipOwner and not be.Touch and (bf.UserInputType == Enum.UserInputType.MouseButton1 or bf.UserInputType == Enum.UserInputType.MouseButton2 or bf.UserInputType == Enum.UserInputType.Keyboard) then
                    self:_hideTooltip()
                end
            end
        )
        return be
    end
    function a2:_showTooltip(a4, a5)
        local a6 = a4._tooltip
        local a7, a8, a9
        if type(a6) == 'table' then
            a7, a8, a9 = a6.Text or a6.Content or a6.Desc, a6.Title or a6.Name, a6.Icon
        elseif a6 ~= nil and a6 ~= false then
            a7 = tostring(a6)
        end
        if (a7 == nil or a7 == '') and (a8 == nil or a8 == '') then
            return
        end
        local ba = self:_tooltipCard()
        ba.Title.Text = a8 or ''
        ba.Title.Visible = a8 ~= nil and a8 ~= ''
        ba.Icon.Visible = a9 ~= nil
        if a9 ~= nil then
            aq(ba.Icon, a9)
        end
        ba.Head.Visible = ba.Title.Visible or a9 ~= nil
        ba.Body.Text = a7 or ''
        ba.Body.Visible = a7 ~= nil and a7 ~= ''
        ba.Fit()
        ba.Body.TextColor3 = z.Text
        ba.Scale.Scale = math.max(self.Scale.Scale, 0.75)
        ba.Touch = a5 == true
        local bb = ba.Shown
        self._tipOwner = a4
        ba.Shown = true
        ba.Generation = (ba.Generation or 0) + 1
        local bc = ba.Holder
        if not bb then
            ba.Snap = true
            bc.Visible = true
            bc.GroupTransparency = 1
            ba.Scale.Scale = ba.Scale.Scale * 0.96
        end
        ah(bc, {GroupTransparency = 0}, 0.14, Enum.EasingStyle.Quad)
        ah(ba.Scale, {Scale = math.max(self.Scale.Scale, 0.75)}, 0.18, Enum.EasingStyle.Back)
    end
    function a2:_hideTooltip(a4)
        local a5 = self._tip
        if not a5 or not a5.Shown or (a4 and self._tipOwner ~= a4) then
            return
        end
        self._tipOwner = nil
        self._tipHiddenAt = os.clock()
        a5.Shown = false
        a5.Generation = (a5.Generation or 0) + 1
        local a6 = a5.Generation
        ah(a5.Holder, {GroupTransparency = 1}, 0.1, Enum.EasingStyle.Quad)
        task.delay(
            0.1,
            function()
                if a5.Generation == a6 then
                    a5.Holder.Visible = false
                end
            end
        )
    end
    function a2:_attachTooltip(a4, a5)
        local a6, a7, a8 = false, 0, nil
        local function a9(ba, bb)
            a7 += 1
            local bc = a7
            task.delay(
                ba,
                function()
                    if a7 ~= bc or not a6 or a4._destroyed or self._destroyed then
                        return
                    end
                    if bb and a8 and (av() - a8).Magnitude > 10 then
                        return
                    end
                    self:_showTooltip(a4, bb)
                end
            )
        end
        table.insert(
            a4._listeners,
            (function()
                local ba = {
                    a5.MouseEnter:Connect(
                        function()
                            if ax() then
                                return
                            end
                            a6 = true
                            local ba = os.clock() - (self._tipHiddenAt or 0) < 0.35 or self._tipOwner ~= nil
                            a9(ba and 0 or 0.45, false)
                        end
                    ),
                    a5.MouseLeave:Connect(
                        function()
                            a6 = false
                            a7 += 1
                            self:_hideTooltip(a4)
                        end
                    ),
                    a5.InputBegan:Connect(
                        function(ba)
                            if ba.UserInputType == Enum.UserInputType.Touch then
                                a6 = true
                                a8 = av()
                                a9(0.5, true)
                            end
                        end
                    ),
                    a5.InputEnded:Connect(
                        function(ba)
                            if ba.UserInputType == Enum.UserInputType.Touch then
                                a6 = false
                                a7 += 1
                                self:_hideTooltip(a4)
                            end
                        end
                    )
                }
                return function()
                    for bb, bc in ipairs(ba) do
                        bc:Disconnect()
                    end
                end
            end)()
        )
    end
    k.DragStyles = {'Outline', 'Brackets', 'Ghost', 'Frame', 'Off'}
    local function a4(a5)
        local a6 = a5.Root
        local a7 = a5.DragStyle or 'Outline'
        local a8 = ai(
            'Frame',
            {
                AnchorPoint = a6.AnchorPoint, Position = a6.Position,
                Size = UDim2.fromOffset(a6.AbsoluteSize.X, a6.AbsoluteSize.Y),
                BackgroundColor3 = a7 == 'Ghost' and z.Background or z.Accent,
                BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 40, Parent = a5.Gui
            }
        )
        aj(a8, UDim.new(0, 10))
        local a9 = {}
        local function ba(bb, bc)
            local bd = {}
            for be in pairs(bc) do
                bd[be] = 1
            end
            table.insert(a9, {Object = bb, Shown = bc, Hidden = bd})
        end
        local function bb(bc, bd)
            for be, bf in ipairs(
                {Vector2.new(0, 0), Vector2.new(1, 0), Vector2.new(0, 1), Vector2.new(1, 1)}
            ) do
                local bg = UDim2.new(bf.X, bf.X == 0 and bd or -bd, bf.Y, bf.Y == 0 and bd or -bd)
                for bh, bi in ipairs({UDim2.fromOffset(bc, 2), UDim2.fromOffset(2, bc)}) do
                    local bj = ai(
                        'Frame',
                        {
                            AnchorPoint = bf, Position = bg, Size = bi, BackgroundColor3 = z.Accent,
                            BackgroundTransparency = 1, BorderSizePixel = 0, Parent = a8
                        }
                    )
                    aj(bj, UDim.new(1, 0))
                    ba(bj, {BackgroundTransparency = 0})
                end
            end
        end
        if a7 == 'Brackets' then
            bb(22, 0)
        elseif a7 == 'Ghost' then
            ba(a8, {BackgroundTransparency = 0.35})
            ba(ak(a8, z.Stroke, 1, 1), {Transparency = 0})
        elseif a7 == 'Frame' then
            ba(ak(a8, z.StrokeHover, 1, 1), {Transparency = 0})
        else
            ba(a8, {BackgroundTransparency = 0.92})
            ba(ak(a8, z.Accent, 1, 1.5), {Transparency = 0.2})
            bb(16, 6)
        end
        local bc = ai('UIScale', {Scale = 1.02, Parent = a8})
        for bd, be in ipairs(a9) do
            ah(be.Object, be.Shown, 0.15, Enum.EasingStyle.Quad)
        end
        ah(bc, {Scale = 1}, 0.25, Enum.EasingStyle.Quint)
        local function bd()
            for be, bf in ipairs(a9) do
                ah(bf.Object, bf.Hidden, 0.2, Enum.EasingStyle.Quad)
            end
            task.delay(
                0.22,
                function()
                    a8:Destroy()
                end
            )
        end
        return a8, bd
    end
    function a2:_enableDrag()
        local a5, a6 = false, false
        local a7, a8 = Vector2.zero, Vector2.zero
        local a9 = nil
        local ba, bb = nil, nil
        local function bc()
            local bd = self.Root
            return bd.AbsolutePosition + bd.AbsoluteSize * bd.AnchorPoint - self.Gui.AbsolutePosition
        end
        local function bd()
            if not ba then
                return
            end
            local be = Vector2.new(ba.Position.X.Offset, ba.Position.Y.Offset)
            if self.KeepOnScreen then
                be = self:_clampedCentre(be)
            end
            if self._clampTween then
                self._clampTween:Cancel()
            end
            self._clampTween = ah(
                self.Root, {Position = UDim2.fromOffset(be.X, be.Y)}, 0.3, Enum.EasingStyle.Quint
            )
            bb()
            ba, bb = nil, nil
        end
        table.insert(
            self._connections,
            b.InputBegan:Connect(
                function(be)
                    if not aw(be) then
                        return
                    end
                    if not self.Open or not self.Root.Visible then
                        return
                    end
                    local bf = av()
                    if self._resizeActive or (self._grip and az(bf, self._grip)) then
                        return
                    end
                    if not az(bf, self.Body) or self:_overControl(bf) then
                        return
                    end
                    if self._clampTween then
                        self._clampTween:Cancel()
                        self._clampTween = nil
                    end
                    a5, a6 = true, false
                    a8 = bf
                    a7 = bf - bc()
                end
            )
        )
        table.insert(
            self._connections,
            b.InputEnded:Connect(
                function(be)
                    if not a5 then
                        return
                    end
                    if aw(be) then
                        a5 = false
                        a9 = nil
                        if ba then
                            bd()
                        else
                            self:_clampToScreen()
                        end
                    end
                end
            )
        )
        table.insert(
            self._frameSteps,
            function(be)
                if not a5 then
                    return
                end
                local bf = av()
                if not a6 and (bf - a8).Magnitude > 3 then
                    a6 = true
                    if self.DragSkeleton then
                        ba, bb = a4(self)
                    end
                end
                if not a6 then
                    return
                end
                if ba and (not self.Open or not self.Root.Visible) then
                    a5 = false
                    bd()
                    return
                end
                a9 = bf - a7
                local bg = 1 - math.exp(-be * 45)
                if ba then
                    local bh = Vector2.new(ba.Position.X.Offset, ba.Position.Y.Offset)
                    local bi = bh:Lerp(a9, bg)
                    ba.Position = UDim2.fromOffset(bi.X, bi.Y)
                else
                    local bh = bc():Lerp(a9, bg)
                    self.Root.Position = UDim2.fromOffset(bh.X, bh.Y)
                end
            end
        )
    end
    function a2:SetDragStyle(a5)
        a5 = table.find(k.DragStyles, a5) and a5 or 'Outline'
        self.DragStyle = a5
        self.DragSkeleton = a5 ~= 'Off'
        return a5
    end
    function a2:GetDragStyle()
        return self.DragStyle
    end
    k.IslandStyles = {'Show on Hover', 'Always Show'}
    function a2:SetIslandStyle(a5)
        a5 = table.find(k.IslandStyles, a5) and a5 or 'Show on Hover'
        self.IslandStyle = a5
        if self._islandSettle then
            self._islandSettle()
        end
        return a5
    end
    function a2:GetIslandStyle()
        return self.IslandStyle
    end
    function a2:SetDragSkeleton(a5)
        if a5 == false then
            self:SetDragStyle('Off')
        elseif self.DragStyle == 'Off' or not self.DragStyle then
            self:SetDragStyle('Outline')
        end
    end
    function a2:_sidebarResize(a5, a6)
        local a7 = a5:FindFirstChild('Divider')
        local a8 = a6
        local function a9(ba, bb)
            if bb ~= false then
                a8 = ba
            end
            local bc = self.Body.AbsoluteSize.X / self.Scale.Scale - 300
            ba = math.floor(math.clamp(ba, 150, math.max(math.min(300, bc), 150)))
            self.SidebarWidth = ba
            a5.Size = UDim2.new(0, ba, 1, 0)
            self.Content.Position = UDim2.fromOffset(ba + 1, 0)
            self.Content.Size = UDim2.new(1, -(ba + 1), 1, 0)
        end
        self.SetSidebarWidth = function(ba, bb)
            a9(tonumber(bb) or F)
        end
        a9(a6)
        local ba = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 6, 1, 0), BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, ZIndex = 6, Parent = a5
            }
        )
        ba:SetAttribute('NoDrag', true)
        local bb, bc, bd = false, 0, a6
        local function be(bf)
            if a7 then
                ah(a7, {BackgroundColor3 = bf and z.Accent or z.Stroke}, 0.15)
            end
        end
        ba.MouseEnter:Connect(
            function()
                be(true)
            end
        )
        ba.MouseLeave:Connect(
            function()
                if not bb then
                    be(false)
                end
            end
        )
        ba.InputBegan:Connect(
            function(bf)
                if bf.UserInputType == Enum.UserInputType.MouseButton1 or bf.UserInputType == Enum.UserInputType.Touch then
                    bb, bc, bd = true, bf.Position.X, self.SidebarWidth
                    a8 = bd
                    be(true)
                end
            end
        )
        self:_listen(
            'Changed',
            function(bf)
                if bb and aA(bf) then
                    a9(bd + (bf.Position.X - bc) / self.Scale.Scale)
                end
            end
        )
        self:_listen(
            'Ended',
            function(bf)
                if bb and (bf.UserInputType == Enum.UserInputType.MouseButton1 or bf.UserInputType == Enum.UserInputType.Touch) then
                    bb = false
                    be(false)
                end
            end
        )
        self.Body:GetPropertyChangedSignal('AbsoluteSize'):Connect(
            function()
                if not bb then
                    a9(a8, false)
                end
            end
        )
    end
    function a2:SetTransparent(a5)
        self.Transparent = a5 == true
        local a6 = self.Transparent
        self._shadowRest = a6 and 0.85 or 0.6
        ah(self.Body, {BackgroundTransparency = a6 and 0.35 or 0}, 0.25)
        local a7 = a6 and 0.5 or (self.Background and 0.45 or 0)
        ah(self.SidebarFill, {BackgroundTransparency = a7}, 0.25)
        if self.Open and not self.Minimized and self.Root.Visible then
            ah(self.Shadow, {ImageTransparency = self._shadowRest}, 0.25)
        end
    end
    local function a5(a6)
        local a7 = {}
        for a8, a9 in ipairs(a6:GetChildren()) do
            if a9:IsA('GuiObject') then
                table.insert(a7, a9)
            end
        end
        table.sort(
            a7,
            function(a8, a9)
                return a8.LayoutOrder < a9.LayoutOrder
            end
        )
        return a7
    end
    local function a6(a7, a8, a9)
        if not a7.Visible and not a9 then
            return
        end
        a7.Visible = false
        task.delay(
            a8,
            function()
                if not a7.Parent then
                    return
                end
                local ba = ai('UIScale', {Scale = 0.94, Parent = a7})
                a7.Visible = true
                ah(ba, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
                task.delay(
                    0.4,
                    function()
                        ba:Destroy()
                    end
                )
            end
        )
    end
    function a2:_revealCards(a7, a8)
        local a9 = a7.CurrentSubTab or a7
        if a9._revealed then
            return
        end
        a9._revealed = true
        local ba = 0
        local function bb(bc)
            a6(bc, (a8 or 0) + ba * 0.035)
            ba += 1
        end
        local bc = a9._columnSet
        for bd, be in ipairs(a5(a9.List)) do
            if bc and be == bc.Holder then
                local bf, bg = a5(bc.Left), a5(bc.Right)
                for bh = 1, math.max(#bf, #bg) do
                    if bf[bh] then
                        bb(bf[bh])
                    end
                    if bg[bh] then
                        bb(bg[bh])
                    end
                end
            else
                bb(be)
            end
        end
    end
    function a2:_playIntro(a7)
        if self._introDone or self._destroyed then
            return
        end
        self._introDone = true
        self:_refreshBackdrop(true)
        task.delay(
            0.4,
            function()
                self:_refreshToggleButton()
            end
        )
        task.delay(
            1.5,
            function()
                if not self._destroyed and not self.MiniBar then
                    self:_buildMiniBar()
                end
            end
        )
        local a8, a9, ba = self.Root, self.Shadow, self.Scale
        if self.CurrentTab then
            self:_revealCards(self.CurrentTab, a7 and 0.15 or 0.25)
        end
        a8.Visible = true
        if a7 then
            ba.Scale = self._fitScale or 1
            a8.Position = UDim2.fromScale(0.5, 0.5)
            self:_fade(0, 0.3)
            ah(self.BodyStroke, {Transparency = 0}, 0.3)
            ah(a9, {ImageTransparency = 0.6}, 0.3)
        else
            a8.Position = UDim2.new(0.5, 0, 0.5, 24)
            ah(ba, {Scale = self._fitScale or 1}, 0.5, Enum.EasingStyle.Back)
            ah(a8, {Position = UDim2.fromScale(0.5, 0.5)}, 0.5, Enum.EasingStyle.Quint)
            self:_fade(0, 0.35)
            ah(self.BodyStroke, {Transparency = 0}, 0.35)
        end
        if not a7 then
            ah(a9, {ImageTransparency = 0.6}, 0.5)
        end
        for bb, bc in ipairs(self.Tabs) do
            a6(bc._button, 0.1 + bb * 0.05, true)
        end
        self.Indicator.Visible = false
        task.delay(
            0.15 + #self.Tabs * 0.05,
            function()
                if self.CurrentTab then
                    self:_placeIndicator(self.CurrentTab)
                end
            end
        )
    end
    function a2:_showLoader(a7)
        local a8 = a7.LoadingDuration or 1.6
        local a9 = self.Gui
        local ba = a7.LoadingSteps or {'Preparing interface', 'Loading icons', 'Almost there'}
        local bb, bc, bd = 340, 22, 24
        local be = 80
        local bf = be + #ba * bd + 18
        local bg = ai(
            'CanvasGroup',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 10),
                Size = UDim2.fromOffset(bb, bf), BackgroundColor3 = z.Background,
                BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 10, Parent = a9
            }
        )
        local bh = aj(bg, UDim.new(0, 12))
        local bi = ak(bg, z.Stroke, 1)
        local bj = ai('UIScale', {Scale = 0.97, Parent = bg})
        local bk = ai(
            'ImageLabel',
            {
                Position = UDim2.fromOffset(-25, -25), Size = UDim2.new(1, 50, 1, 50),
                BackgroundTransparency = 1, Image = A.Shadow, ImageColor3 = Color3.new(0, 0, 0),
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0, Parent = bg
            }
        )
        local bl = ai(
            'CanvasGroup', {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = bg}
        )
        local bm = ai(
            'ImageLabel',
            {
                Position = UDim2.fromOffset(bc, bc), Size = UDim2.fromOffset(30, 30),
                BackgroundTransparency = 1, ImageColor3 = z.Accent, ScaleType = Enum.ScaleType.Fit,
                Parent = bl
            }
        )
        aq(bm, a7.Icon or A.Logo, true)
        local bn = bc + 42
        local bo = am(
            {
                Position = UDim2.fromOffset(bn, bc - 2), Size = UDim2.new(1, -(bn + 70), 0, 18),
                Text = a7.LoadingTitle or a7.Title or 'Airflow', TextSize = 15, FontFace = D.Bold,
                Parent = bl
            }
        )
        local bp = am(
            {
                Position = UDim2.fromOffset(bn, bc + 17), Size = UDim2.new(1, -(bn + 70), 0, 15),
                Text = a7.LoadingText or a7.Subtitle or 'Loading', TextSize = 12,
                FontFace = D.Regular, TextColor3 = z.Muted, Parent = bl
            }
        )
        local bq = am(
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -bc, 0, bc + 6),
                Size = UDim2.fromOffset(56, 16), Text = '0%', TextSize = 13, FontFace = D.Medium,
                TextColor3 = z.Muted, TextXAlignment = Enum.TextXAlignment.Right, Parent = bl
            }
        )
        ai(
            'Frame',
            {
                Position = UDim2.fromOffset(bc, be - 14), Size = UDim2.new(1, -bc * 2, 0, 1),
                BackgroundColor3 = z.Stroke, BorderSizePixel = 0, Parent = bl
            }
        )
        local br = {}
        for bs, bt in ipairs(ba) do
            local bu = ai(
                'Frame',
                {
                    Position = UDim2.fromOffset(bc, be + (bs - 1) * bd),
                    Size = UDim2.new(1, -bc * 2, 0, bd), BackgroundTransparency = 1, Parent = bl
                }
            )
            local bv = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 7, 0.5, 0),
                    Size = UDim2.fromOffset(6, 6), BackgroundColor3 = z.Surface3,
                    BorderSizePixel = 0, Parent = bu
                }
            )
            aj(bv, UDim.new(1, 0))
            local bw = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 7, 0.5, 0),
                    Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1, Visible = false,
                    Parent = bu
                }
            )
            aj(bw, UDim.new(1, 0))
            local bx = ai('UIStroke', {Color = z.Accent, Thickness = 2, Parent = bw})
            ai(
                'UIGradient',
                {
                    Transparency = NumberSequence.new(
                        {
                            NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0),
                            NumberSequenceKeypoint.new(0.501, 1), NumberSequenceKeypoint.new(1, 1)
                        }
                    ), Parent = bx
                }
            )
            local by = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 7, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                    ImageColor3 = z.Accent, ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit,
                    Parent = bu
                }
            )
            aq(by, 'check')
            local bz = am(
                {
                    Position = UDim2.fromOffset(24, 0), Size = UDim2.new(1, -24, 1, 0),
                    Text = tostring(bt), TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextTransparency = 1, Parent = bu
                }
            )
            br[bs] = {Dot = bv, Spinner = bw, Check = by, Label = bz, State = 'pending'}
            task.delay(
                0.15 + bs * 0.06,
                function()
                    if bg.Parent and br[bs].State == 'pending' then
                        ah(bz, {TextTransparency = 0.45}, 0.3)
                    end
                end
            )
        end
        local function bs(bt, bu)
            local bv = br[bt]
            if not bv or bv.State == bu then
                return
            end
            bv.State = bu
            bv.Dot.Visible = bu == 'pending'
            bv.Spinner.Visible = bu == 'active'
            ah(bv.Check, {ImageTransparency = bu == 'done' and 0 or 1}, 0.2)
            ah(
                bv.Label,
                {
                    TextTransparency = bu == 'pending' and 0.45 or 0,
                    TextColor3 = bu == 'active' and z.Text or z.Muted
                }, 0.2
            )
        end
        local bt = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 2), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Parent = bl
            }
        )
        local bu = ai(
            'Frame',
            {Size = UDim2.fromScale(0, 1), BackgroundColor3 = z.Accent, BorderSizePixel = 0, Parent = bt}
        )
        ah(
            bg, {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)}, 0.45,
            Enum.EasingStyle.Quint
        )
        ah(bj, {Scale = 1}, 0.45, Enum.EasingStyle.Quint)
        ah(bk, {ImageTransparency = 0.55}, 0.4)
        ah(bu, {Size = UDim2.fromScale(0.85, 1)}, a8 * 0.8, Enum.EasingStyle.Quart)
        local bv
        bv = d.RenderStepped:Connect(
            function(bw)
                if not bg.Parent then
                    bv:Disconnect()
                    return
                end
                bq.Text = math.floor(bu.Size.X.Scale * 100 + 0.5) .. '%'
                for bx, by in ipairs(br) do
                    if by.State == 'active' then
                        by.Spinner.Rotation = (by.Spinner.Rotation + bw * 360) % 360
                    end
                end
            end
        )
        task.spawn(s)
        for bw in ipairs(ba) do
            task.delay(
                a8 * (bw - 1) / #ba,
                function()
                    if not bg.Parent then
                        return
                    end
                    if bw > 1 then
                        bs(bw - 1, 'done')
                    end
                    bs(bw, 'active')
                end
            )
        end
        local function bw()
            for bx in ipairs(br) do
                bs(bx, 'done')
            end
        end
        local function bx()
            bw()
            ah(bl, {GroupTransparency = 1}, 0.18)
            local by = self._fitScale or 1
            local bz = self.Root.Size
            ah(
                bg,
                {Size = UDim2.fromOffset(bz.X.Offset * by, bz.Y.Offset * by), Position = UDim2.fromScale(
                    0.5, 0.5
                )}, 0.5, Enum.EasingStyle.Quint
            )
            ah(bh, {CornerRadius = UDim.new(0, k._radius(10))}, 0.5, Enum.EasingStyle.Quint)
            ah(bj, {Scale = 1}, 0.5, Enum.EasingStyle.Quint)
            task.delay(
                0.28,
                function()
                    self:_playIntro(true)
                    ah(bg, {GroupTransparency = 1}, 0.25)
                    ah(bi, {Transparency = 1}, 0.2)
                    ah(bk, {ImageTransparency = 1}, 0.2)
                end
            )
            task.delay(
                0.6,
                function()
                    bg:Destroy()
                end
            )
        end
        local function by()
            bw()
            ah(bl, {GroupTransparency = 1}, 0.18)
        end
        local function bz(bA, bB)
            local bC, bD, bE = 360, 24, 220
            local bF = bA.Color or z.Accent
            local bG = ai(
                'CanvasGroup',
                {
                    AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0),
                    Size = UDim2.new(0, bC, 1, 0), BackgroundTransparency = 1,
                    GroupTransparency = 1, ZIndex = 5, Parent = bg
                }
            )
            local bH = ai(
                'Frame',
                {
                    Position = UDim2.fromOffset(bD, bD), Size = UDim2.fromOffset(44, 44),
                    BackgroundColor3 = bF, BackgroundTransparency = 0.86, BorderSizePixel = 0,
                    Parent = bG
                }
            )
            aj(bH, UDim.new(0, 12))
            ak(bH, bF, 1).Transparency = 0.6
            local bI = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, ImageColor3 = bF,
                    ScaleType = Enum.ScaleType.Fit, Parent = bH
                }
            )
            aq(bI, bA.Icon or 'info')
            am(
                {
                    Position = UDim2.fromOffset(bD + 58, bA.Subtitle and bD + 3 or bD + 12),
                    Size = UDim2.new(1, -(bD * 2 + 58), 0, 20), Text = bA.Title, TextSize = 17,
                    Parent = bG
                }
            )
            if bA.Subtitle then
                am(
                    {
                        Position = UDim2.fromOffset(bD + 58, bD + 25),
                        Size = UDim2.new(1, -(bD * 2 + 58), 0, 16), Text = tostring(bA.Subtitle),
                        TextSize = 13, TextColor3 = bF, Parent = bG
                    }
                )
            end
            local bJ = ai(
                'ScrollingFrame',
                {
                    Position = UDim2.fromOffset(bD, bD + 60), Size = UDim2.new(1, -bD * 2, 0, 16),
                    BackgroundTransparency = 1, BorderSizePixel = 0,
                    ScrollBarThickness = E and 4 or 3, ScrollBarImageColor3 = z.Accent,
                    ScrollBarImageTransparency = 0.4,
                    ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(),
                    Parent = bG
                }
            )
            local bK = am(
                {
                    Size = UDim2.new(1, -8, 0, 0), Text = tostring(bA.Text), TextSize = 13,
                    FontFace = D.Regular, TextColor3 = z.Muted, TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = bJ
                }
            )
            local bL = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, bD, 1, -bD + 4),
                    Size = UDim2.new(1, -bD * 2, 0, 34), BackgroundTransparency = 1, Parent = bG
                }
            )
            ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = bL
                }
            )
            local bM = false
            local bN = nil
            if not bA.Block and bA.RememberText and aW.Available() then
                local bO = E and 20 or 16
                bN = ai(
                    'TextButton',
                    {
                        AnchorPoint = Vector2.new(0, 1),
                        Position = UDim2.new(0, bD, 1, -bD + 4 - 34 - 12),
                        Size = UDim2.new(1, -bD * 2, 0, E and 28 or 22), BackgroundTransparency = 1,
                        Text = '', AutoButtonColor = false, Parent = bG
                    }
                )
                local bP = ai(
                    'Frame',
                    {
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromOffset(bO, bO), BackgroundColor3 = z.Surface2,
                        BorderSizePixel = 0, Parent = bN
                    }
                )
                aj(bP, UDim.new(0, 4))
                local bQ = ak(bP, z.Stroke, 1)
                local bR = ai(
                    'ImageLabel',
                    {
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                        Size = UDim2.fromOffset(bO - 4, bO - 4), BackgroundTransparency = 1,
                        ImageColor3 = z.AccentDark, ImageTransparency = 1,
                        ScaleType = Enum.ScaleType.Fit, Parent = bP
                    }
                )
                aq(bR, 'check')
                local bS = am(
                    {
                        Position = UDim2.fromOffset(bO + 8, 0),
                        Size = UDim2.new(1, -(bO + 8), 1, 0), Text = bA.RememberText, TextSize = 12,
                        FontFace = D.Regular, TextColor3 = z.Muted, Parent = bN
                    }
                )
                bN.MouseEnter:Connect(
                    function()
                        ah(bQ, {Color = bM and z.Accent or z.StrokeHover}, 0.12)
                        ah(bS, {TextColor3 = z.Text}, 0.12)
                    end
                )
                bN.MouseLeave:Connect(
                    function()
                        ah(bQ, {Color = bM and z.Accent or z.Stroke}, 0.2)
                        ah(bS, {TextColor3 = bM and z.Text or z.Muted}, 0.2)
                    end
                )
                bN.MouseButton1Click:Connect(
                    function()
                        bM = not bM
                        ah(bP, {BackgroundColor3 = bM and z.Accent or z.Surface2}, 0.15)
                        ah(bQ, {Color = bM and z.Accent or z.Stroke}, 0.15)
                        ah(bR, {ImageTransparency = bM and 0 or 1}, 0.15)
                        ah(bS, {TextColor3 = bM and z.Text or z.Muted}, 0.15)
                    end
                )
            end
            local bO = false
            local function bP(bQ, bR, bS, bT)
                local bU = ai(
                    'TextButton',
                    {
                        Size = UDim2.fromOffset(0, 34), AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = bR and z.Accent or z.Surface2,
                        BackgroundTransparency = bR and 0.12 or 0, BorderSizePixel = 0, Text = '',
                        AutoButtonColor = false, LayoutOrder = bS, Parent = bL
                    }
                )
                aj(bU, UDim.new(0, 7))
                local bV = ak(bU, bR and z.Accent or z.Stroke, 1)
                bV.Transparency = bR and 0.4 or 0
                al(bU, 14, 14)
                am(
                    {
                        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                        Text = bQ, TextSize = 13, TextColor3 = bR and z.AccentDark or z.Text,
                        TextXAlignment = Enum.TextXAlignment.Center, Parent = bU
                    }
                )
                bU.MouseEnter:Connect(
                    function()
                        if bR then
                            ah(bU, {BackgroundTransparency = 0}, 0.12)
                            ah(bV, {Transparency = 0}, 0.12)
                        else
                            ah(bV, {Color = z.StrokeHover}, 0.12)
                        end
                    end
                )
                bU.MouseLeave:Connect(
                    function()
                        if bR then
                            ah(bU, {BackgroundTransparency = 0.12}, 0.2)
                            ah(bV, {Transparency = 0.4}, 0.2)
                        else
                            ah(bV, {Color = z.Stroke}, 0.2)
                        end
                    end
                )
                bU.MouseButton1Click:Connect(
                    function()
                        if bO then
                            return
                        end
                        bO = true
                        bT()
                    end
                )
            end
            if bA.ExitText ~= false then
                bP(
                    bA.ExitText or 'Exit', bA.Block, 1,
                    function()
                        if bA.Callback then
                            task.spawn(bA.Callback, false)
                        end
                        ah(
                            bg, {GroupTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 12)},
                            0.25, Enum.EasingStyle.Quint
                        )
                        ah(bk, {ImageTransparency = 1}, 0.2)
                        task.delay(
                            0.25,
                            function()
                                self:Destroy()
                            end
                        )
                    end
                )
            end
            if not bA.Block then
                bP(
                    bA.ContinueText or 'Continue', true, 2,
                    function()
                        if bM and bA.Remember then
                            bA.Remember()
                        end
                        if bA.Callback then
                            task.spawn(bA.Callback, true)
                        end
                        ah(bG, {GroupTransparency = 1}, 0.15)
                        task.delay(
                            0.15,
                            function()
                                bG:Destroy()
                                bB()
                            end
                        )
                    end
                )
            end
            local bQ = false
            local function bR()
                local bS, bT = pcall(
                    function()
                        local bS = Instance.new('GetTextBoundsParams')
                        bS.Text = bK.Text
                        bS.Font = bK.FontFace
                        bS.Size = bK.TextSize
                        bS.Width = bC - bD * 2 - 8
                        return game:GetService('TextService'):GetTextBoundsAsync(bS)
                    end
                )
                return bS and bT and math.ceil(bT.Y) + 2 or bK.TextBounds.Y
            end
            local function bS(bT)
                local bU = math.max(bR(), 16)
                local bV = math.min(bU, bE)
                bK.Size = UDim2.new(1, -8, 0, bU)
                bJ.Size = UDim2.new(1, -bD * 2, 0, bV)
                bJ.CanvasSize = UDim2.fromOffset(0, bU)
                local bW = bD + 60 + bV + 18 + 34 + bD - 4
                if bN then
                    bW += bN.Size.Y.Offset + 10
                end
                ah(bg, {Size = UDim2.fromOffset(bC, bW)}, bT, Enum.EasingStyle.Quint)
            end
            bK:GetPropertyChangedSignal('TextBounds'):Connect(
                function()
                    if bQ and bg.Parent and bG.Parent then
                        bS(0.2)
                    end
                end
            )
            task.delay(
                0.15,
                function()
                    if not bg.Parent then
                        return
                    end
                    bQ = true
                    bS(0.35)
                    task.delay(
                        0.12,
                        function()
                            ah(bG, {GroupTransparency = 0}, 0.3)
                            bH.Size = UDim2.fromOffset(34, 34)
                            bH.Position = UDim2.fromOffset(bD + 5, bD + 5)
                            ah(
                                bH,
                                {Size = UDim2.fromOffset(44, 44), Position = UDim2.fromOffset(
                                    bD, bD
                                )}, 0.45, Enum.EasingStyle.Back
                            )
                        end
                    )
                end
            )
        end
        local function bA(bB, bC)
            if not bg.Parent then
                return
            end
            local bD = bB[bC]
            if not bD then
                bx()
                return
            end
            bz(
                bD,
                function()
                    bA(bB, bC + 1)
                end
            )
        end
        task.delay(
            a8,
            function()
                ah(bu, {Size = UDim2.fromScale(1, 1)}, 0.25, Enum.EasingStyle.Quint)
                task.delay(
                    0.25,
                    function()
                        if not bg.Parent then
                            return
                        end
                        if a7._prompts then
                            by()
                            bA(a7._prompts, 1)
                        else
                            bx()
                        end
                    end
                )
            end
        )
    end
    function a2:_fitToScreen(a7)
        local a8 = self.Gui.AbsoluteSize
        if a8.X == 0 or a8.Y == 0 then
            return
        end
        local a9 = self.Root.Size
        local ba = (self._uiScale or 1) * (self._adaptive ~= false and k._adaptiveFactor(a8) or 1)
        local bb = math.min(
            ba, (a8.X - 24) / math.max(a9.X.Offset, 1), (a8.Y - 24) / math.max(a9.Y.Offset, 1)
        )
        self._fitScale = math.max(bb, 0.45)
        if self._introDone and self.Open then
            if a7 then
                self.Scale.Scale = self._fitScale
            else
                ah(self.Scale, {Scale = self._fitScale}, 0.2)
            end
        end
    end
    function k._adaptiveFactor(a7)
        if E then
            return 1
        end
        local a8 = math.min(a7.X / 1920, a7.Y / 1020)
        if a8 > 0.9 and a8 < 1.15 then
            return 1
        end
        return math.clamp(math.floor(a8 * 20 + 0.5) / 20, 0.85, 1.75)
    end
    function a2:SetAdaptiveSize(a7)
        self._adaptive = a7 ~= false
        self:_fitToScreen()
        task.delay(
            0.22,
            function()
                if not self._destroyed then
                    self:_clampToScreen()
                end
            end
        )
    end
    function a2:GetAdaptiveSize()
        return self._adaptive ~= false
    end
    function a2:SetUIScale(a7)
        a7 = math.clamp(tonumber(a7) or 1, 0.6, 1.5)
        self.UIScale = a7
        self._uiScale = a7
        self:_fitToScreen()
        task.delay(
            0.22,
            function()
                if not self._destroyed then
                    self:_clampToScreen()
                end
            end
        )
    end
    function a2:GetUIScale()
        return self._uiScale or 1
    end
    k.DensityModes = {Compact = 0.55, Default = 1, Comfortable = 1.45}
    k.Density = 'Default'
    function k._spaced(a7, a8)
        if a7 <= 0 then
            return 0
        end
        return math.max(math.floor(a7 * a8 + (a8 - 1) * 4 + 0.5), 0)
    end
    function k._space(a7, a8)
        local a9 = k.DensityModes[k.Density] or 1
        if a7:IsA('UIListLayout') or a7:IsA('UIGridLayout') then
            a7:SetAttribute('Space', a8)
            a7.Padding = UDim.new(0, k._spaced(a8, a9))
        elseif a7:IsA('UIPadding') then
            a7:SetAttribute('SpaceL', a8[1])
            a7:SetAttribute('SpaceR', a8[2])
            a7:SetAttribute('SpaceT', a8[3])
            a7:SetAttribute('SpaceB', a8[4])
            a7.PaddingLeft = UDim.new(0, math.floor(a8[1] * math.sqrt(a9) + 0.5))
            a7.PaddingRight = UDim.new(0, math.floor(a8[2] * math.sqrt(a9) + 0.5))
            a7.PaddingTop = UDim.new(0, k._spaced(a8[3], a9))
            a7.PaddingBottom = UDim.new(0, k._spaced(a8[4], a9))
        end
        return a7
    end
    function k:SetDensity(a7)
        if type(a7) == 'string' then
            for a8 in pairs(k.DensityModes) do
                if a8:lower() == a7:lower() then
                    a7 = a8
                    break
                end
            end
        end
        if not k.DensityModes[a7] then
            a7 = 'Default'
        end
        k.Density = a7
        for a8, a9 in ipairs(k.Windows) do
            if a9.Gui and a9.Gui.Parent then
                for ba, bb in ipairs(a9.Gui:GetDescendants()) do
                    local bc = bb:GetAttribute('Space')
                    if bc then
                        k._space(bb, bc)
                    elseif bb:GetAttribute('SpaceL') then
                        k._space(
                            bb,
                            {
                                bb:GetAttribute('SpaceL'), bb:GetAttribute('SpaceR'),
                                bb:GetAttribute('SpaceT'), bb:GetAttribute('SpaceB')
                            }
                        )
                    end
                end
            end
        end
        return a7
    end
    function a2:SetDensity(a7)
        return k:SetDensity(a7)
    end
    function a2:GetDensity()
        return k.Density
    end
    function a2:_clampedCentre(a7)
        local a8 = self.Gui.AbsoluteSize
        local a9 = self.Root.AbsoluteSize / 2
        return Vector2.new(
            math.clamp(a7.X, math.min(a9.X, a8.X / 2), math.max(a8.X - a9.X, a8.X / 2)),
            math.clamp(a7.Y, math.min(a9.Y, a8.Y / 2), math.max(a8.Y - a9.Y, a8.Y / 2))
        )
    end
    function a2:_clampToScreen()
        if not self.KeepOnScreen or self._resizeActive then
            return
        end
        local a7 = self.Root
        local a8 = a7.AbsolutePosition + a7.AbsoluteSize / 2 - self.Gui.AbsolutePosition
        local a9 = self:_clampedCentre(a8)
        if (a9 - a8).Magnitude > 0.5 then
            self._clampTween = ah(
                a7, {Position = UDim2.fromOffset(a9.X, a9.Y)}, 0.25, Enum.EasingStyle.Quint
            )
        end
    end
    function a2:_createOpenButton(a7)
        local a8 = self.Gui
        local a9 = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14),
                Size = UDim2.fromOffset(0, 40), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = z.Background, BorderSizePixel = 0, Text = '',
                AutoButtonColor = false, ZIndex = 30, Parent = a8
            }
        )
        aj(a9, UDim.new(1, 0))
        ak(a9, z.Stroke)
        al(a9, 12, 16)
        local ba = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, ImageColor3 = z.Accent,
                ScaleType = Enum.ScaleType.Fit, ZIndex = 31, Parent = a9
            }
        )
        aq(ba, a7.Icon or A.Logo, true)
        am(
            {
                Position = UDim2.fromOffset(28, 0), Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X, Text = a7.Title or 'Airflow', TextSize = 13,
                TextTruncate = Enum.TextTruncate.None, ZIndex = 31, Parent = a9
            }
        )
        self.OpenButton = a9
        local bb, bc = false, false
        local bd = Vector2.zero
        a9.InputBegan:Connect(
            function(be)
                if aw(be) then
                    bb = true
                    bc = false
                    bd = av() - a9.AbsolutePosition
                end
            end
        )
        table.insert(
            self._connections,
            b.InputChanged:Connect(
                function(be)
                    if not bb then
                        return
                    end
                    if aA(be) then
                        local bf = av() - bd - a8.AbsolutePosition
                        if (bf - (a9.AbsolutePosition - a8.AbsolutePosition)).Magnitude > 3 then
                            bc = true
                        end
                        a9.AnchorPoint = Vector2.new(0, 0)
                        a9.Position = UDim2.fromOffset(
                            math.clamp(bf.X, 0, math.max(a8.AbsoluteSize.X - a9.AbsoluteSize.X, 0)),
                            math.clamp(bf.Y, 0, math.max(a8.AbsoluteSize.Y - a9.AbsoluteSize.Y, 0))
                        )
                    end
                end
            )
        )
        table.insert(
            self._connections,
            b.InputEnded:Connect(
                function(be)
                    if bb and aw(be) then
                        bb = false
                        if not bc then
                            self:Toggle()
                        end
                    end
                end
            )
        )
    end
    function a2:_toggleButtonAllowed()
        return self._toggleEnabled and (E or self._togglePlatform == 'Both')
    end
    function a2:_refreshToggleButton()
        local a7 = self.ToggleButton
        if not a7 then
            return
        end
        local a8 = self._introDone and not self._destroyed and self:_toggleButtonAllowed()
        if a8 and not a7.Visible then
            a7.Visible = true
            a7.Size = UDim2.fromOffset(0, 0)
            ah(
                a7, {Size = UDim2.fromOffset(self._toggleSize, self._toggleSize)}, 0.45,
                Enum.EasingStyle.Quint
            )
        elseif not a8 then
            a7.Visible = false
        end
        local a9 = self.Minimized or not self.Open
        ah(
            self._toggleStroke,
            {Color = a9 and z.Accent or z.Stroke, Transparency = a9 and 0.3 or 0}, 0.35
        )
        local ba = self._toggleIcon
        ah(ba, {Rotation = a9 and 180 or 0}, 0.5, Enum.EasingStyle.Quint)
        if not ba:GetAttribute('CustomIcon') then
            ah(ba, {ImageColor3 = a9 and z.Text or z.Accent}, 0.35)
        end
    end
    function a2:_createToggleButton(a7)
        local a8 = self.Gui
        local a9 = tonumber(a7.Size) or (E and 56 or 50)
        local ba = math.floor(a9 * 0.46)
        self._toggleEnabled = a7.Enabled ~= false
        self._togglePlatform = a7.Platform == 'Both' and 'Both' or 'Mobile'
        self._toggleSize = a9
        local bb = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = a7.Position or UDim2.new(0, 18 + a9 / 2, 0.5, 0),
                Size = UDim2.fromOffset(a9, a9), BackgroundColor3 = z.Background,
                BorderSizePixel = 0, Text = '', AutoButtonColor = false, ClipsDescendants = true,
                Visible = false, ZIndex = 30, Parent = a8
            }
        )
        aj(bb, UDim.new(0, 12))
        local bc = ak(bb, z.Stroke)
        local bd = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(ba, ba), BackgroundTransparency = 1, ImageColor3 = z.Accent,
                ScaleType = Enum.ScaleType.Fit, ZIndex = 31, Parent = bb
            }
        )
        local be = ai('UIScale', {Parent = bb})
        self.ToggleButton = bb
        self._toggleStroke = bc
        self._toggleIcon = bd
        self:SetToggleButtonIcon(a7.Icon or 'layout-grid')
        local bf, bg = false, false
        local bh = Vector2.zero
        bb.InputBegan:Connect(
            function(bi)
                if aw(bi) then
                    bf = true
                    bg = false
                    bh = av() - bb.AbsolutePosition
                    ah(be, {Scale = 0.94}, 0.18, Enum.EasingStyle.Quint)
                end
            end
        )
        table.insert(
            self._connections,
            b.InputChanged:Connect(
                function(bi)
                    if not bf or not aA(bi) then
                        return
                    end
                    local bj = av() - bh - a8.AbsolutePosition
                    if (bj - (bb.AbsolutePosition - a8.AbsolutePosition)).Magnitude > 3 then
                        bg = true
                    end
                    if bg then
                        bb.AnchorPoint = Vector2.zero
                        bb.Position = UDim2.fromOffset(
                            math.clamp(bj.X, 0, math.max(a8.AbsoluteSize.X - bb.AbsoluteSize.X, 0)),
                            math.clamp(bj.Y, 0, math.max(a8.AbsoluteSize.Y - bb.AbsoluteSize.Y, 0))
                        )
                    end
                end
            )
        )
        table.insert(
            self._connections,
            b.InputEnded:Connect(
                function(bi)
                    if not bf or not aw(bi) then
                        return
                    end
                    bf = false
                    ah(be, {Scale = 1}, 0.4, Enum.EasingStyle.Quint)
                    if bg then
                        return
                    end
                    aE(bb)
                    if not self.Open then
                        self:Toggle(true)
                    elseif self.Minimized then
                        self:Restore()
                    else
                        self:Minimize()
                    end
                end
            )
        )
    end
    function a2:SetToggleButton(a7)
        self._toggleEnabled = a7 ~= false
        self:_refreshToggleButton()
    end
    function a2:SetToggleButtonPlatform(a7)
        self._togglePlatform = a7 == 'Both' and 'Both' or 'Mobile'
        self:_refreshToggleButton()
    end
    function a2:SetToggleButtonIcon(a7)
        local a8 = self._toggleIcon
        if not a8 then
            return
        end
        a8.Image = ''
        aq(a8, a7)
        if a8.Image == '' then
            aq(a8, A.Logo)
        end
        if not a8:GetAttribute('CustomIcon') then
            ah(a8, {ImageColor3 = (self.Minimized or not self.Open) and z.Text or z.Accent}, 0)
        end
    end
    function a2:_enableResize(a7)
        local a8 = self.MaxSize or Vector2.new(math.huge, math.huge)
        self._minSize = a7
        local a9 = self.Root
        local ba = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 4, 1, 4),
                Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1, Active = true,
                ZIndex = 20, Parent = a9
            }
        )
        self._grip = ba
        local bb = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromOffset(12, 12),
                Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1, ZIndex = 20,
                Parent = ba
            }
        )
        aj(bb, UDim.new(0, 10))
        local bc = ai(
            'UIStroke', {Color = z.Muted, Thickness = 2, Transparency = 0.55, Parent = bb}
        )
        ai(
            'UIGradient',
            {
                Rotation = 45,
                Transparency = NumberSequence.new(
                    {
                        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.55, 1),
                        NumberSequenceKeypoint.new(0.85, 0), NumberSequenceKeypoint.new(1, 0)
                    }
                ), Parent = bc
            }
        )
        local function bd(be)
            ah(
                bc, {Color = be and z.Accent or z.Muted, Transparency = be and 0 or 0.55},
                be and 0.15 or 0.3, Enum.EasingStyle.Quint
            )
        end
        local be = 20
        local bf = false
        local bg = Vector2.zero
        local bh = Vector2.zero
        local bi = Vector2.zero
        local bj = Vector2.zero
        local bk = Vector2.zero
        local bl = Vector2.zero
        local function bm()
            return Vector2.new(a9.Size.X.Offset, a9.Size.Y.Offset)
        end
        local function bn()
            if a9.AnchorPoint == Vector2.zero then
                return
            end
            if self._clampTween then
                self._clampTween:Cancel()
                self._clampTween = nil
            end
            local bo = a9.AbsolutePosition - self.Gui.AbsolutePosition
            a9.AnchorPoint = Vector2.zero
            a9.Position = UDim2.fromOffset(bo.X, bo.Y)
        end
        local function bo()
            local bp = a9.AbsolutePosition - self.Gui.AbsolutePosition
            local bq = a9.AbsoluteSize / 2
            a9.AnchorPoint = Vector2.new(0.5, 0.5)
            a9.Position = UDim2.fromOffset(bp.X + bq.X, bp.Y + bq.Y)
        end
        local function bp(bq)
            return Vector2.new(
                math.floor(math.clamp(bq.X, a7.X, a8.X) + 0.5),
                math.floor(math.clamp(bq.Y, a7.Y, a8.Y) + 0.5)
            )
        end
        ba.InputBegan:Connect(
            function(bq)
                if not aw(bq) or not self.Open then
                    return
                end
                if not self._resizeActive then
                    bn()
                    bi = bm()
                    bj = Vector2.zero
                    bl = bi
                end
                self._resizeActive = true
                bf = true
                bg = bi
                bh = av()
                bk = bp(bg)
                bd(true)
            end
        )
        ba.MouseEnter:Connect(
            function()
                if not bf then
                    bd(true)
                end
            end
        )
        ba.MouseLeave:Connect(
            function()
                if not bf then
                    bd(false)
                end
            end
        )
        table.insert(
            self._connections,
            b.InputEnded:Connect(
                function(bq)
                    if bf and aw(bq) then
                        bf = false
                        bd(false)
                    end
                end
            )
        )
        table.insert(
            self._frameSteps,
            function(bq)
                if not self._resizeActive then
                    return
                end
                if bf then
                    local br = (av() - bh) / self.Scale.Scale
                    bk = bp(bg + br)
                end
                local br = math.min(bq, 1 / 30)
                local bs = math.exp(-be * br)
                local bt = bi - bk
                local bu = (bj + bt * be) * br
                bj = (bj - bu * be) * bs
                bi = bk + (bt + bu) * bs
                local bv = Vector2.new(math.floor(bi.X + 0.5), math.floor(bi.Y + 0.5))
                if bv ~= bl then
                    bl = bv
                    a9.Size = UDim2.fromOffset(bv.X, bv.Y)
                end
                if not bf and (bi - bk).Magnitude < 0.3 and bj.Magnitude < 3 then
                    bi = bk
                    bj = Vector2.zero
                    bl = bk
                    a9.Size = UDim2.fromOffset(bk.X, bk.Y)
                    bo()
                    self._resizeActive = false
                    self:_fitToScreen()
                    self:_clampToScreen()
                end
            end
        )
    end
    function a2:GetSize()
        return Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
    end
    function a2:SetSize(a7, a8)
        if typeof(a7) == 'UDim2' then
            a7 = Vector2.new(a7.X.Offset, a7.Y.Offset)
        end
        if typeof(a7) ~= 'Vector2' or self._resizeActive then
            return
        end
        local a9 = self._minSize or Vector2.zero
        local ba = self.MaxSize or Vector2.new(math.huge, math.huge)
        a7 = Vector2.new(
            math.floor(math.clamp(a7.X, a9.X, ba.X) + 0.5),
            math.floor(math.clamp(a7.Y, a9.Y, ba.Y) + 0.5)
        )
        if a7 == self:GetSize() then
            return
        end
        local bb = (a8 or not self.Root.Visible) and 0 or 0.3
        ah(self.Root, {Size = UDim2.fromOffset(a7.X, a7.Y)}, bb, Enum.EasingStyle.Quint)
        task.delay(
            bb + 0.02,
            function()
                if not self._destroyed then
                    self:_fitToScreen()
                    self:_clampToScreen()
                end
            end
        )
    end
    local a7 = 1
    local a8 = 'airflow:'
    local function a9(ba, bb)
        return ba.ConfigFolder .. '/' .. bb .. '.json'
    end
    local function ba()
        return type(writefile) == 'function' and type(readfile) == 'function' and type(isfile) == 'function'
    end
    local function bb(bc)
        if type(isfolder) ~= 'function' or type(makefolder) ~= 'function' then
            return
        end
        local bd = ''
        for be in tostring(bc):gmatch('[^/\\]+') do
            bd = bd == '' and be or bd .. '/' .. be
            if not isfolder(bd) then
                makefolder(bd)
            end
        end
    end
    local function bc(bd)
        return string.format(
            '%02x%02x%02x', math.floor(bd.R * 255 + 0.5), math.floor(bd.G * 255 + 0.5),
            math.floor(bd.B * 255 + 0.5)
        )
    end
    local function bd(be)
        if type(be) == 'table' then
            if type(be.Hex) == 'string' then
                be = be.Hex
            elseif type(be[1]) == 'number' then
                return Color3.new(be[1], be[2] or 0, be[3] or 0)
            end
        end
        if type(be) == 'string' then
            local bf, bg, bh = be:match('^%s*#?(%x%x)(%x%x)(%x%x)%s*$')
            if bf then
                return Color3.fromRGB(tonumber(bf, 16), tonumber(bg, 16), tonumber(bh, 16))
            end
        end
        return nil
    end
    local function be(bf)
        local bg = bf._type
        local bh = bf:Get()
        if type(bf._saveValue) == 'function' then
            bh = bf:_saveValue()
        end
        if bg == 'Keybind' then
            return {Type = bg, Value = bh and bh.Name or nil}
        elseif bg == 'ColorPicker' then
            return {Type = bg, Value = typeof(bh) == 'Color3' and {Hex = bc(bh)} or nil}
        end
        return {Type = bg, Value = bh}
    end
    local function bf(bg, bh, bi)
        local bj = bg._type
        local bk = bh.Value
        if bj == 'Keybind' then
            bg:Set(type(bk) == 'string' and Enum.KeyCode[bk] or nil, bi)
        elseif bj == 'ColorPicker' then
            local bl = bd(bk)
            if bl then
                bg:Set(bl, bi)
            end
        elseif bj == 'Dropdown' then
            bg:Set(bk, bi)
        elseif bj == 'Toggle' then
            if type(bk) == 'boolean' then
                bg:Set(bk, bi)
            end
        elseif bj == 'Slider' or bj == 'Stepper' or bj == 'Progress' then
            local bl = tonumber(bk)
            if bl then
                bg:Set(bl, bi)
            end
        elseif bk ~= nil then
            bg:Set(bk, bi)
        end
    end
    local function bg(bh, bi)
        return type(bi) == 'table' and (bi.Type == nil or bi.Type == bh._type)
    end
    local function bh(bi)
        local bj = {}
        if bi and bi._pendingFlags then
            for bk, bl in pairs(bi._pendingFlags) do
                bj[bk] = bl.Entry
            end
        end
        for bk, bl in pairs(k.Flags) do
            if bl._type and type(bl.Get) == 'function' then
                local bm, bn = pcall(be, bl)
                if bm then
                    bj[bk] = bn
                end
            end
        end
        return bj
    end
    function a2:_applyFlags(bi, bj)
        bj = bj == true
        self._pendingFlags = {}
        for bk, bl in pairs(bi) do
            local bm = k.Flags[bk]
            if bm and type(bm.Set) == 'function' then
                if bg(bm, bl) then
                    pcall(bf, bm, bl, bj)
                end
            elseif type(bl) == 'table' then
                self._pendingFlags[bk] = {Entry = bl, Silent = bj}
            end
        end
    end
    function a2:_flagCreated(bi, bj)
        local bk, bl = pcall(be, bj)
        if bk then
            bj._defaultEntry = bl
        end
        local bm = self._pendingFlags and self._pendingFlags[bi]
        if not bm then
            return
        end
        task.defer(
            function()
                if self._pendingFlags[bi] ~= bm or k.Flags[bi] ~= bj or bj._destroyed then
                    return
                end
                self._pendingFlags[bi] = nil
                if bg(bj, bm.Entry) then
                    pcall(bf, bj, bm.Entry, bm.Silent)
                end
            end
        )
    end
    function a2:_configChanged()
        for bi, bj in ipairs(self._configListeners) do
            aJ(bj)
        end
    end
    function a2:OnConfigChanged(bi)
        table.insert(self._configListeners, bi)
        return function()
            local bj = table.find(self._configListeners, bi)
            if bj then
                table.remove(self._configListeners, bj)
            end
        end
    end
    local function bi(bj)
        return type(bj) == 'string' and bj ~= '' and not bj:find('[\\/:%*%?"<>|]')
    end
    local function bj(bk, bl, bm)
        return e:JSONEncode(
            {Folder = bk.ConfigFolder, Name = bl, Version = a7, Config = e:JSONEncode(bm)}
        )
    end
    local bk = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/]]
    local bl = {}
    for bm = 1, #bk do
        bl[bk:byte(bm)] = bm - 1
    end
    local function bm(bn)
        if #bn % 4 ~= 0 then
            return nil
        end
        local bo = {}
        for bp = 1, #bn, 4 do
            local bq, br = 0, 0
            for bs = 0, 3 do
                local bt = bn:byte(bp + bs)
                local bu = bl[bt]
                if bt == 61 and bp + 3 >= #bn then
                    br += 1
                    bu = 0
                elseif bu == nil or br > 0 then
                    return nil
                end
                bq = bq * 64 + bu
            end
            if br > 2 then
                return nil
            end
            local bs = string.char(
                bit32.extract(bq, 16, 8), bit32.extract(bq, 8, 8), bit32.extract(bq, 0, 8)
            )
            table.insert(bo, bs:sub(1, 3 - br))
        end
        return table.concat(bo)
    end
    local function bn(bo)
        bo = tostring(bo or ''):match('^%s*(.-)%s*$')
        if bo:sub(1, #a8) == a8 then
            bo = bm((bo:sub(#a8 + 1):gsub('%s', '')))
            if not bo then
                return nil, 'invalid config code'
            end
        end
        local bp, bq = pcall(
            function()
                return e:JSONDecode(bo)
            end
        )
        if not bp or type(bq) ~= 'table' then
            return nil, 'invalid config code'
        end
        local br = {}
        if type(bq.Config) == 'string' or (type(bq.Config) == 'table' and bq.Config.Type == nil) then
            br.Folder = type(bq.Folder) == 'string' and bq.Folder or nil
            br.Name = type(bq.Name) == 'string' and bq.Name or nil
            br.Version = tonumber(bq.Version)
            local bs = bq.Config
            if type(bs) == 'string' then
                bp, bs = pcall(
                    function()
                        return e:JSONDecode(bq.Config)
                    end
                )
                if not bp then
                    return nil, 'invalid config code'
                end
            end
            if type(bs) ~= 'table' then
                return nil, 'invalid config code'
            end
            bq = bs
        end
        for bs, bt in pairs(bq) do
            if type(bs) ~= 'string' or type(bt) ~= 'table' then
                return nil, 'invalid config code'
            end
        end
        return bq, br
    end
    local function bo(bp, bq, br)
        if not bi(bq) then
            return false, 'invalid config name'
        end
        if not ba() then
            return false, 'file API unavailable'
        end
        local bs, bt = pcall(bj, bp, bq, br)
        if not bs then
            return false, 'could not encode config'
        end
        bb(bp.ConfigFolder)
        return pcall(writefile, a9(bp, bq), bt)
    end
    local function bp(bq, br)
        if not ba() then
            return nil, 'file API unavailable'
        end
        if not bi(br) then
            return nil, 'invalid config name'
        end
        local bs = a9(bq, br)
        if not isfile(bs) then
            return nil, 'no config named ' .. tostring(br)
        end
        local bt, bu = pcall(readfile, bs)
        if not bt or type(bu) ~= 'string' then
            return nil, 'could not read ' .. br
        end
        local bv, bw = bn(bu)
        if not bv then
            return nil, 'config is not valid JSON'
        end
        return bv, bw
    end
    function a2:ConfigExists(bq)
        return bi(bq) and ba() and isfile(a9(self, bq)) or false
    end
    function a2:SaveConfig(bq)
        bq = bq or self.ConfigName
        if not bq then
            return false, 'no config name'
        end
        local br, bs = bo(self, bq, bh(self))
        if br then
            self.ConfigName = bq
        end
        return br, bs
    end
    function a2:LoadConfig(bq, br)
        bq = bq or self.ConfigName
        if not bq then
            return false, 'no config name'
        end
        local bs, bt = bp(self, bq)
        if not bs then
            return false, bt
        end
        self:_applyFlags(bs, br)
        self.ConfigName = bq
        self.LoadedConfig = bq
        self:_configChanged()
        return true
    end
    function a2:DeleteConfig(bq)
        if not ba() or type(delfile) ~= 'function' then
            return false, 'file API unavailable'
        end
        if not bi(bq) then
            return false, 'invalid config name'
        end
        local br = a9(self, bq)
        if not isfile(br) then
            return false, 'no config named ' .. bq
        end
        local bs, bt = pcall(delfile, br)
        if not bs then
            return false, bt
        end
        if self.LoadedConfig == bq then
            self.LoadedConfig = nil
        end
        self:_configChanged()
        return true
    end
    function a2:RenameConfig(bq, br)
        if not bi(br) then
            return false, 'invalid config name'
        end
        if bq == br then
            return true
        end
        if self:ConfigExists(br) then
            return false, br .. ' already exists'
        end
        local bs, bt = bp(self, bq)
        if not bs then
            return false, bt
        end
        local bu
        bu, bt = bo(self, br, bs)
        if not bu then
            return false, bt
        end
        if type(delfile) == 'function' then
            pcall(delfile, a9(self, bq))
        end
        if self.LoadedConfig == bq then
            self.LoadedConfig = br
        end
        if self.ConfigName == bq then
            self.ConfigName = br
        end
        for bv, bw in ipairs({'Global', 'Account'}) do
            if self:GetAutoload(bw) == bq then
                self:SetAutoload(br, bw)
            end
        end
        self:_configChanged()
        return true
    end
    function a2:ListConfigs()
        local bq = {}
        if type(listfiles) ~= 'function' or type(isfolder) ~= 'function' or not isfolder(
            self.ConfigFolder
        ) then
            return bq
        end
        local br, bs = pcall(listfiles, self.ConfigFolder)
        if not br or type(bs) ~= 'table' then
            return bq
        end
        for bt, bu in ipairs(bs) do
            local bv = bu:match('([^/\\]+)%.json$')
            if bv then
                table.insert(bq, bv)
            end
        end
        table.sort(
            bq,
            function(bt, bu)
                return bt:lower() < bu:lower()
            end
        )
        return bq
    end
    function a2:ResetConfig(bq)
        self._pendingFlags = {}
        for br, bs in pairs(k.Flags) do
            if bs._defaultEntry and type(bs.Set) == 'function' then
                pcall(bf, bs, bs._defaultEntry, bq == true)
            end
        end
        self:_configChanged()
        return true
    end
    local function bq(br)
        if type(isfolder) ~= 'function' or not isfolder(br) then
            return true
        end
        if type(delfolder) == 'function' and pcall(delfolder, br) and not isfolder(br) then
            return true
        end
        if type(listfiles) == 'function' then
            local bs, bt = pcall(listfiles, br)
            for bu, bv in ipairs(bs and bt or {}) do
                if isfolder(bv) then
                    bq(bv)
                elseif type(delfile) == 'function' then
                    pcall(delfile, bv)
                end
            end
        end
        if type(delfolder) == 'function' then
            pcall(delfolder, br)
        end
        return not isfolder(br)
    end
    function a2:ClearWorkspace()
        local br = bq(self.ConfigFolder)
        self.LoadedConfig = nil
        for bs, bt in ipairs(self._workspaceListeners or {}) do
            aJ(bt)
        end
        self:_configChanged()
        return br
    end
    function a2:ExportConfig(br)
        local bs, bt
        if br then
            bs, bt = bp(self, br)
            if not bs then
                return nil, bt
            end
        else
            bs = bh(self)
            br = self.LoadedConfig or self.ConfigName
        end
        local bu, bv = pcall(bj, self, br, bs)
        if not bu then
            return nil, 'could not encode config'
        end
        return bv
    end
    function a2:DecodeConfig(br)
        return bn(br)
    end
    function a2:ImportConfig(br, bs, bt)
        local bu, bv = bn(br)
        if not bu then
            return false, bv
        end
        if not bt and bv.Folder and bv.Folder ~= self.ConfigFolder then
            return false, 'config is for ' .. bv.Folder
        end
        if bs == true then
            bs = bv.Name
            if not bi(bs) then
                return false, 'config has no usable name'
            end
        end
        if bs then
            local bw, bx = bo(self, bs, bu)
            if not bw then
                return false, bx
            end
        end
        self:_applyFlags(bu)
        if bs then
            self.ConfigName = bs
            self.LoadedConfig = bs
        end
        self:_configChanged()
        return true, nil, bs
    end
    local function br(bs)
        if not ba() or not isfile(bs) then
            return nil
        end
        local bt, bu = pcall(readfile, bs)
        if bt and type(bu) == 'string' and bu ~= '' then
            return bu
        end
        return nil
    end
    local function bs(bt)
        if ba() and type(delfile) == 'function' and isfile(bt) then
            pcall(delfile, bt)
        end
    end
    local function bt(bu)
        return bu.ConfigFolder .. '/configsettings.txt'
    end
    function a2:_readConfigSettings()
        local bu = br(bt(self))
        if bu then
            local bv, bw = pcall(
                function()
                    return e:JSONDecode(bu)
                end
            )
            if bv and type(bw) == 'table' then
                return bw
            end
        end
        return {}
    end
    function a2:_writeConfigSettings(bu)
        if not ba() then
            return false, 'file API unavailable'
        end
        local bv = self:_readConfigSettings()
        for bw, bx in pairs(bu) do
            bv[bw] = bx
        end
        bb(self.ConfigFolder)
        return pcall(writefile, bt(self), e:JSONEncode(bv))
    end
    local function bu(bv, bw)
        if bw == 'Account' then
            return bv.ConfigFolder .. '/autoload_' .. tostring(j and j.UserId or 0) .. '.txt'
        end
        return bv.ConfigFolder .. '/autoload.txt'
    end
    function a2:GetAutoloadMode()
        return self:_readConfigSettings().AutoloadMode == 'Account' and 'Account' or 'Global'
    end
    function a2:GetAutoload(bv)
        if bv then
            return br(bu(self, bv))
        end
        return br(bu(self, 'Account')) or br(bu(self, 'Global'))
    end
    function a2:SetAutoload(bv, bw)
        if not ba() then
            return false, 'file API unavailable'
        end
        bw = bw or self:GetAutoloadMode()
        local bx, by = true, nil
        if bv == nil or bv == '' then
            bs(bu(self, bw))
            if bw == 'Global' then
                bs(bu(self, 'Account'))
            end
        else
            bb(self.ConfigFolder)
            bx, by = pcall(writefile, bu(self, bw), tostring(bv))
            if bx and bw == 'Global' then
                bs(bu(self, 'Account'))
            end
        end
        self:_configChanged()
        return bx, by
    end
    function a2:SetAutoloadMode(bv)
        bv = bv == 'Account' and 'Account' or 'Global'
        if bv == self:GetAutoloadMode() then
            return true
        end
        local bw = self:GetAutoload()
        local bx, by = self:_writeConfigSettings({AutoloadMode = bv})
        if not bx then
            return false, by
        end
        bs(bu(self, bv == 'Account' and 'Global' or 'Account'))
        if bw then
            return self:SetAutoload(bw, bv)
        end
        self:_configChanged()
        return true
    end
    function a2:LoadAutoload(bv)
        local bw = self:GetAutoload()
        if not bw then
            return false, 'no autoload config'
        end
        return self:LoadConfig(bw, bv)
    end
    k._themeListeners = {}
    local function bv(bw)
        if typeof(bw) == 'Color3' then
            return bw
        elseif type(bw) == 'string' then
            local bx, by, bz = bw:match('^%s*#?(%x%x)(%x%x)(%x%x)%s*$')
            if bx then
                return Color3.fromRGB(tonumber(bx, 16), tonumber(by, 16), tonumber(bz, 16))
            end
        elseif type(bw) == 'table' then
            local bx, by, bz = bw[1] or bw.R, bw[2] or bw.G, bw[3] or bw.B
            if tonumber(bx) and tonumber(by) and tonumber(bz) then
                return Color3.fromRGB(bx, by, bz)
            end
        end
        return nil
    end
    local function bw(bx)
        return string.format(
            '#%02X%02X%02X', math.floor(bx.R * 255 + 0.5), math.floor(bx.G * 255 + 0.5),
            math.floor(bx.B * 255 + 0.5)
        )
    end
    k._toneTags = {}
    for bx, by in ipairs(n) do
        k._toneTags[string.lower(by)] = by
    end
    function k._color(bx)
        if type(bx) == 'string' then
            local by = k._toneTags[string.lower(bx)]
            if by then
                return z[by]
            end
        end
        return bv(bx)
    end
    function k._rich(bx)
        bx = tostring(bx == nil and '' or bx)
        if not string.find(bx, '<', 1, true) then
            return bx
        end
        return (string.gsub(
            bx, '<(/?)(%a+%d*)>',
            function(by, bz)
                local bA = k._toneTags[string.lower(bz)]
                if not bA then
                    return nil
                end
                if by == '/' then
                    return '</font>'
                end
                return '<font color="' .. bw(z[bA]) .. '">'
            end
        ))
    end
    function k.Colorize(...)
        local bx = {...}
        if bx[1] == k then
            table.remove(bx, 1)
        end
        local by, bz = tostring(bx[1] == nil and '' or bx[1]), bx[2]
        local bA = type(bz) == 'string' and k._toneTags[string.lower(bz)]
        if bA then
            return '<' .. bA .. '>' .. by .. '</' .. bA .. '>'
        end
        local bB = bv(bz)
        if not bB then
            return by
        end
        return '<font color="' .. bw(bB) .. '">' .. by .. '</font>'
    end
    function k:SetCornerRadius(bx, by)
        bx = math.clamp(math.floor((tonumber(bx) or 10) + 0.5), 0, 20)
        k.Roundness = bx / 10
        for bz, bA in pairs(k._cornerBases) do
            if not bz.Parent then
                k._cornerBases[bz] = nil
            else
                local bB = UDim.new(0, math.floor(bA * k.Roundness + 0.5))
                if by then
                    bz.CornerRadius = bB
                else
                    ah(bz, {CornerRadius = bB}, 0.25, Enum.EasingStyle.Quint)
                end
            end
        end
        return bx
    end
    function k:GetCornerRadius()
        return math.floor(k.Roundness * 10 + 0.5)
    end
    function k:SetTheme(bx, by)
        if type(bx) == 'string' then
            local bz = k.ThemePresets[bx]
            if not bz then
                return false
            end
            k.ThemeName = bx
            bx = bz
        elseif type(bx) ~= 'table' then
            return false
        end
        local bz = false
        for bA, bB in ipairs(n) do
            local bC = bv(bx[bB])
            if bC and bC ~= z[bB] then
                z[bB] = bC
                bz = true
            end
        end
        if not bz then
            return true
        end
        _()
        Y()
        af(by and 0 or 0.3)
        for bA, bB in pairs(S) do
            if bA.Parent then
                pcall(bB)
            end
        end
        for bA, bB in ipairs(k._themeListeners) do
            pcall(bB)
        end
        return true
    end
    function k:GetTheme()
        local bx = {}
        for by, bz in ipairs(n) do
            bx[bz] = z[bz]
        end
        return bx
    end
    function k:SetDefaultTheme(bx)
        k.DefaultTheme = bx
        if bx == nil then
            return true
        end
        local by = false
        for bz, bA in ipairs(k.Windows) do
            if not bA._destroyed then
                if bA:GetDefaultTheme() then
                    return true
                end
                by = true
            end
        end
        return k:SetTheme(bx, not by)
    end
    function k:GetDefaultTheme()
        return k.DefaultTheme
    end
    local function bx(by)
        return by.ConfigFolder .. '/themes'
    end
    function a2:SaveTheme(by)
        if not ba() then
            return false, 'file API unavailable'
        end
        if type(by) ~= 'string' or by == '' then
            return false, 'theme needs a name'
        end
        bb(self.ConfigFolder)
        bb(bx(self))
        local bz = {}
        for bA, bB in ipairs(n) do
            bz[bB] = bw(z[bB])
        end
        return pcall(
            function()
                writefile(bx(self) .. '/' .. by .. '.json', e:JSONEncode(bz))
            end
        )
    end
    function a2:LoadTheme(by, bz)
        if k.ThemePresets[by] then
            return k:SetTheme(by, bz)
        end
        local bA = br(bx(self) .. '/' .. tostring(by) .. '.json')
        if not bA then
            return false, 'no theme named ' .. tostring(by)
        end
        local bB, bC = pcall(
            function()
                return e:JSONDecode(bA)
            end
        )
        if not bB or type(bC) ~= 'table' then
            return false, 'theme is not valid JSON'
        end
        k.ThemeName = by
        return k:SetTheme(bC, bz)
    end
    function a2:DeleteTheme(by)
        if not ba() or type(delfile) ~= 'function' then
            return false, 'file API unavailable'
        end
        local bz = bx(self) .. '/' .. tostring(by) .. '.json'
        if not isfile(bz) then
            return false, 'no theme named ' .. tostring(by)
        end
        delfile(bz)
        if self:GetDefaultTheme() == by then
            self:SetDefaultTheme(nil)
        end
        return true
    end
    function a2:ListThemes()
        local by = {}
        if type(listfiles) ~= 'function' or type(isfolder) ~= 'function' or not isfolder(bx(self)) then
            return by
        end
        for bz, bA in ipairs(listfiles(bx(self))) do
            local bB = bA:match('([^/\\]+)%.json$')
            if bB then
                table.insert(by, bB)
            end
        end
        table.sort(by)
        return by
    end
    function a2:GetDefaultTheme()
        return br(bx(self) .. '/default.txt')
    end
    function a2:SetDefaultTheme(by)
        if not ba() then
            return false, 'file API unavailable'
        end
        bb(self.ConfigFolder)
        bb(bx(self))
        local bz = bx(self) .. '/default.txt'
        if by == nil or by == '' then
            if isfile(bz) and type(delfile) == 'function' then
                pcall(delfile, bz)
            end
            return true
        end
        return pcall(writefile, bz, tostring(by))
    end
    function a2:_applyDefaultTheme()
        local by = self:GetDefaultTheme()
        if by then
            local bz, bA = pcall(self.LoadTheme, self, by, true)
            if bz and bA then
                return
            end
        end
        if k.DefaultTheme ~= nil then
            pcall(k.SetTheme, k, k.DefaultTheme, true)
        end
    end
    k.BackgroundPresets = {
        ['Deep Violet'] = 'rbxassetid://136310484943077',
        ['Blood Red'] = 'rbxassetid://121343473918667', ['Cyanic'] = 'rbxassetid://95656189244173',
        ['Amber Glow'] = 'rbxassetid://107795771598485',
        ['Bloomings'] = 'rbxassetid://133541508207801',
        ['Lavender Pink'] = 'rbxassetid://126107479485287'
    }
    k.BackgroundPresetOrder = {
        'Deep Violet', 'Blood Red', 'Cyanic', 'Amber Glow', 'Bloomings', 'Lavender Pink'
    }
    k._imageExtensions = {png = true, jpg = true, jpeg = true, webp = true, gif = true, bmp = true}
    function a2:_backgroundFolder()
        return self.ConfigFolder .. '/backgrounds'
    end
    function a2:_trimBackground(by)
        return (tostring(by or ''):match('^%s*(.-)%s*$'))
    end
    function a2:_resolveBackground(by)
        by = self:_trimBackground(by)
        local bz = k.BackgroundPresets[by]
        if bz then
            return bz
        end
        if by:match('^%d+$') then
            return 'rbxassetid://' .. by
        end
        if by:match('^rbxassetid://%d+') or by:match('^rbxasset://') or by:match('^rbxthumb://') or by:match(
            '^https?://www%.roblox%.com/asset'
        ) then
            return by
        end
        local bA = ba() and typeof(getcustomasset) == 'function'
        if by:match('^https?://') then
            if not bA then
                return nil, 'web images need writefile and getcustomasset'
            end
            local bB = by:match('^[^?#]+') or by
            local bC = (bB:match('%.(%w+)$') or 'png'):lower()
            if not k._imageExtensions[bC] then
                bC = 'png'
            end
            local bD = (bB:gsub('^https?://', ''):gsub('[^%w]', '_')):sub(-60)
            local bE = self:_backgroundFolder() .. '/cache'
            local bF = bE .. '/' .. bD .. '_' .. #by .. '.' .. bC
            if not isfile(bF) then
                local bG, bH = pcall(
                    function()
                        local bG = (syn and syn.request) or http_request or request
                        if bG then
                            local bH = bG({Url = by, Method = 'GET'})
                            return bH and bH.Body
                        end
                        return game:HttpGet(by, true)
                    end
                )
                if not bG or type(bH) ~= 'string' or #bH < 128 then
                    return nil, 'could not download the image'
                end
                local bI = bH:sub(1, 64):lower()
                if bI:find('<!doctype') or bI:find('<html') then
                    return nil, 'that link is a web page, not an image'
                end
                bb(bE)
                if not pcall(writefile, bF, bH) then
                    return nil, 'could not save the image'
                end
            end
            local bG, bH = pcall(getcustomasset, bF)
            if bG and type(bH) == 'string' and bH ~= '' then
                return bH
            end
            pcall(delfile, bF)
            return nil, 'the downloaded file is not an image'
        end
        if bA then
            for bB, bC in ipairs({self:_backgroundFolder() .. '/' .. by, by}) do
                if isfile(bC) then
                    local bD, bE = pcall(getcustomasset, bC)
                    if bD and type(bE) == 'string' and bE ~= '' then
                        return bE
                    end
                    return nil, 'could not load ' .. by
                end
            end
        end
        return nil, 'no image called ' .. by
    end
    function a2:SetBackground(by)
        self._backgroundGeneration += 1
        local bz = self._backgroundGeneration
        local bA = self._backgroundImage
        by = by ~= false and self:_trimBackground(by) or ''
        if by == '' or by == 'None' then
            self.Background = nil
            ah(bA, {ImageTransparency = 1}, 0.25)
            task.delay(
                0.25,
                function()
                    if self._backgroundGeneration == bz then
                        bA.Visible = false
                        bA.Image = ''
                    end
                end
            )
            self:SetTransparent(self.Transparent)
            return true
        end
        local bB, bC = self:_resolveBackground(by)
        if self._backgroundGeneration ~= bz or self._destroyed then
            return false, 'replaced by a newer background'
        end
        if not bB then
            return false, bC
        end
        self.Background = by
        bA.Image = bB
        bA.Visible = true
        ah(bA, {ImageTransparency = self.BackgroundTransparency}, 0.3)
        self:SetTransparent(self.Transparent)
        return true
    end
    function a2:GetBackground()
        return self.Background
    end
    function a2:SetBackgroundTransparency(by)
        self.BackgroundTransparency = math.clamp(tonumber(by) or 0.35, 0, 1)
        if self.Background then
            ah(self._backgroundImage, {ImageTransparency = self.BackgroundTransparency}, 0.15)
        end
    end
    function a2:ListBackgrounds()
        local by = table.clone(k.BackgroundPresetOrder)
        local bz = self:_backgroundFolder()
        if type(listfiles) == 'function' and type(isfolder) == 'function' and isfolder(bz) then
            local bA = {}
            for bB, bC in ipairs(listfiles(bz)) do
                local bD = bC:match('([^/]+)$')
                local bE = bD and bD:match('%.(%w+)$')
                if bE and k._imageExtensions[bE:lower()] then
                    table.insert(bA, bD)
                end
            end
            table.sort(bA)
            for bB, bC in ipairs(bA) do
                table.insert(by, bC)
            end
        end
        return by
    end
    local function by(bz, bA, bB)
        local bC = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -10),
                Size = UDim2.fromOffset(200, 70), BackgroundTransparency = 1, Parent = bz
            }
        )
        local bD = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ImageTransparency = 0.15, ScaleType = Enum.ScaleType.Fit, Parent = bC
            }
        )
        aq(bD, bA)
        local bE = am(
            {
                Position = UDim2.fromOffset(0, 36), Size = UDim2.new(1, 0, 0, 16), Text = bB,
                TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Center, Parent = bC
            }
        )
        return bC, bE, bD
    end
    local function bz(bA, bB)
        bB = bB or 0
        bA.GroupTransparency = 1
        bA.Position = UDim2.fromOffset(0, bB + 14)
        bA.Visible = true
        ah(
            bA, {GroupTransparency = 0, Position = UDim2.fromOffset(0, bB)}, 0.32,
            Enum.EasingStyle.Quint
        )
    end
    local function bA(bB)
        bB = math.max(math.floor(bB), 0)
        local bC = math.floor(bB / 86400)
        local bD = math.floor(bB / 3600) % 24
        local bE = math.floor(bB / 60) % 60
        if bC > 0 then
            return string.format('%dd %dh', bC, bD)
        elseif bD > 0 then
            return string.format('%dh %dm', bD, bE)
        elseif bE > 0 then
            return string.format('%dm %ds', bE, bB % 60)
        end
        return string.format('%ds', bB)
    end
    local function bB(bC)
        if type(bC) ~= 'string' or bC == '' then
            return 'Studio'
        end
        if #bC > 16 then
            return bC:sub(1, 8) .. '...' .. bC:sub(-4)
        end
        return bC
    end
    local function bC(bD)
        local bE = setclipboard or toclipboard or (Clipboard and Clipboard.set)
        if type(bE) ~= 'function' then
            return false
        end
        return (pcall(bE, tostring(bD)))
    end
    local function bD(bE)
        local bF = string.format(
            [[https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&limit=100&excludeFullGames=true]],
            game.PlaceId, bE
        )
        local bG, bH = pcall(
            function()
                return game:HttpGet(bF)
            end
        )
        if not bG or type(bH) ~= 'string' then
            return nil
        end
        local bI, bJ = pcall(
            function()
                return e:JSONDecode(bH)
            end
        )
        if not bI or type(bJ) ~= 'table' or type(bJ.data) ~= 'table' then
            return nil
        end
        return bJ.data
    end
    local function bE(bF, bG, bH, bI)
        local bJ = ai(
            'TextButton',
            {
                Size = UDim2.fromOffset(30, 16), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Text = '', AutoButtonColor = false, LayoutOrder = bH, Parent = bF
            }
        )
        aj(bJ, UDim.new(1, 0))
        ak(bJ)
        local bK = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0),
                Size = UDim2.fromOffset(12, 12), BackgroundColor3 = z.Muted, BorderSizePixel = 0,
                Parent = bJ
            }
        )
        aj(bK, UDim.new(1, 0))
        local bL = bG == true
        local function bM(bN)
            local bO = bN and 0.22 or 0
            ah(bJ, {BackgroundColor3 = bL and z.Accent or z.Surface3}, bO)
            ah(
                bK,
                {
                    Position = bL and UDim2.new(0, 16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
                    BackgroundColor3 = bL and z.AccentDark or z.Muted
                }, bO, Enum.EasingStyle.Back
            )
        end
        bJ.MouseButton1Click:Connect(
            function()
                bL = not bL
                bM(true)
                aJ(bI, bL)
            end
        )
        bM(false)
        return bJ
    end
    local function bF(bG, bH, bI, bJ)
        local bK = ai(
            'TextButton',
            {
                BackgroundColor3 = z.Surface3, BackgroundTransparency = 0.45, BorderSizePixel = 0,
                Text = '', AutoButtonColor = false, ClipsDescendants = true, Parent = bG
            }
        )
        for bL, bM in pairs(bI) do
            bK[bL] = bM
        end
        aj(bK, UDim.new(0, 6))
        local bL = ak(bK)
        local bM = am(
            {
                Size = UDim2.fromScale(1, 1), Text = bH, TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Center, Parent = bK
            }
        )
        if bK.AutomaticSize == Enum.AutomaticSize.X then
            bM.Size = UDim2.new(0, 0, 1, 0)
            bM.AutomaticSize = Enum.AutomaticSize.X
            bM.TextTruncate = Enum.TextTruncate.None
            al(bK, 14, 14)
        end
        bK.MouseEnter:Connect(
            function()
                ah(bK, {BackgroundTransparency = 0.15}, 0.12)
                ah(bL, {Color = z.StrokeHover}, 0.12)
            end
        )
        bK.MouseLeave:Connect(
            function()
                ah(bK, {BackgroundTransparency = 0.45}, 0.25)
                ah(bL, {Color = z.Stroke}, 0.25)
            end
        )
        bK.MouseButton1Click:Connect(
            function()
                aE(bK)
                aJ(bJ)
            end
        )
        return bK, bM
    end
    local function bG(bH, bI, bJ)
        local bK = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, bI), BackgroundColor3 = z.Surface2, BorderSizePixel = 0,
                LayoutOrder = bJ, Parent = bH
            }
        )
        bK:SetAttribute('NoDrag', true)
        aj(bK, UDim.new(0, 10))
        ak(bK)
        return bK
    end
    local bH = {
        Players = {'users', 'Players'}, Friends = {'user-check', 'Friends'},
        Execs = {'zap', 'Execs'}, Session = {'timer', 'Session'}, Uptime = {'timer', 'Session'},
        FPS = {'gauge', 'FPS'}, Ping = {'wifi', 'Ping'}, Executor = {'terminal', 'Executor'},
        Game = {'gamepad-2', 'Game'}, Region = {'globe', 'Region'}, Time = {'clock', 'Time'},
        ServerAge = {'server', 'Server age'}, Memory = {'cpu', 'Memory'}
    }
    function k._healthColor(bI, bJ, bK, bL)
        if type(bI) ~= 'number' then
            return z.Text
        end
        if bL then
            return bI <= bJ and z.Success or bI <= bK and z.Warning or z.Error
        end
        return bI >= bJ and z.Success or bI >= bK and z.Warning or z.Error
    end
    local function bI(bJ)
        if not ba() then
            return nil
        end
        local bK = bJ .. '/executions.txt'
        local bL = 0
        pcall(
            function()
                bb(bJ)
                if isfile(bK) then
                    bL = tonumber(readfile(bK)) or 0
                end
            end
        )
        bL += 1
        pcall(writefile, bK, tostring(bL))
        return bL
    end
    local function bJ(bK, bL, bM, bN, bO)
        local bP = ai(
            'ScrollingFrame',
            {
                Position = UDim2.fromOffset(0, bM), Size = UDim2.new(1, 0, 1, -bM),
                BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
                ScrollBarImageColor3 = z.Accent, ScrollBarImageTransparency = 0.5,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = bL
            }
        )
        k._space(al(bP, 24, 24, 2, 24), {24, 24, 2, 24})
        k._space(
            ai(
                'UIListLayout',
                {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = bP}
            ), 8
        )
        bK.List = bP
        bK._items = {}
        bK._groupboxes = {}
        bK._childCount = 0
        bK._emptyText = bO
        bK._empty, bK._emptyCaption = by(bL, bN, bO)
        bP.ChildAdded:Connect(
            function(bQ)
                if bQ:IsA('GuiObject') then
                    bK._childCount += 1
                    bK:_refreshEmpty()
                end
            end
        )
        bP.ChildRemoved:Connect(
            function(bQ)
                if bQ:IsA('GuiObject') then
                    bK._childCount = math.max(bK._childCount - 1, 0)
                    bK:_refreshEmpty()
                end
            end
        )
        bK:_refreshEmpty()
        return bP
    end
    function aS:_refreshEmpty()
        local bK = self._empty
        if not bK then
            return
        end
        if self._subTabs then
            bK.Visible = false
        else
            bK.Visible = self._childCount == 0
        end
    end
    function aS:_columns()
        if self._columnSet then
            return self._columnSet
        end
        local bK = ai(
            'Frame',
            {
                Name = 'Columns', Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                LayoutOrder = 100000, Parent = self.List
            }
        )
        local bL = k._space(
            ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = bK
                }
            ), 10
        )
        local function bM(bN)
            local bO = ai(
                'Frame',
                {
                    Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, LayoutOrder = bN, Parent = bK
                }
            )
            k._space(
                ai(
                    'UIListLayout',
                    {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = bO}
                ), 10
            )
            return bO
        end
        local bN = {Holder = bK, Left = bM(1), Right = bM(2), Counts = {0, 0}, Stacked = false}
        local bO = self.Window
        local function bP()
            local bQ = bK.AbsoluteSize.X / bO.Scale.Scale
            if bQ <= 0 then
                return
            end
            local bR = bQ < O
            local bS = bL.Padding.Offset
            if bR == bN.Stacked and bS == bN.Gap then
                return
            end
            bN.Stacked = bR
            bN.Gap = bS
            bL.FillDirection = bR and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
            local bT = bR and UDim2.new(1, 0, 0, 0) or UDim2.new(0.5, -bS / 2, 0, 0)
            bN.Left.Size = bT
            bN.Right.Size = bT
        end
        bK:GetPropertyChangedSignal('AbsoluteSize'):Connect(bP)
        bL:GetPropertyChangedSignal('Padding'):Connect(bP)
        task.defer(bP)
        self._columnSet = bN
        return bN
    end
    function aS:Groupbox(bK, bL)
        if self._groupbox then
            return self.Parent:Groupbox(bK, bL)
        end
        bK = l(bK, {Title = 'Name'})
        if bL ~= nil and bK.Icon == nil then
            bK.Icon = bL
        end
        local bM = self.Window
        local bN = self:_columns()
        local bO = bK.Side
        if bO == 'Left' or bO == 1 then
            bO = 1
        elseif bO == 'Right' or bO == 2 then
            bO = 2
        else
            bO = bN.Counts[1] <= bN.Counts[2] and 1 or 2
        end
        bN.Counts[bO] += 1
        local bP = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = z.Surface2, BorderSizePixel = 0, LayoutOrder = bN.Counts[bO],
                Parent = bO == 1 and bN.Left or bN.Right
            }
        )
        bP:SetAttribute('NoDrag', true)
        aj(bP, UDim.new(0, 10))
        ak(bP)
        ai('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder, Parent = bP})
        local bQ = ai(
            'TextButton',
            {
                Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Text = '', AutoButtonColor = false, LayoutOrder = 1, Parent = bP
            }
        )
        aj(bQ, UDim.new(0, 10))
        local bR = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 10), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Parent = bQ
            }
        )
        local bS = 14
        if bK.Icon then
            local bT = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                    ImageColor3 = z.Accent, ScaleType = Enum.ScaleType.Fit, ZIndex = 2, Parent = bQ
                }
            )
            aq(bT, bK.Icon)
            bS = 37
        end
        local bT = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ScaleType = Enum.ScaleType.Fit, ZIndex = 2, Parent = bQ
            }
        )
        aq(bT, 'chevron-down')
        local bU = bK.PopOut ~= false
        local bV, bW
        if bU then
            bV = ai(
                'TextButton',
                {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0),
                    Size = UDim2.fromOffset(24, 24), BackgroundColor3 = z.Surface2,
                    BackgroundTransparency = 1, BorderSizePixel = 0, Text = '',
                    AutoButtonColor = false, ZIndex = 3, Parent = bQ
                }
            )
            aj(bV, UDim.new(0, 6))
            bW = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(13, 13), BackgroundTransparency = 1,
                    ImageColor3 = z.Muted, ImageTransparency = E and 0 or 0.45,
                    ScaleType = Enum.ScaleType.Fit, ZIndex = 3, Parent = bV
                }
            )
            aq(bW, 'picture-in-picture-2')
        end
        local bX = am(
            {
                Position = UDim2.fromOffset(bS, 0),
                Size = UDim2.new(1, -(bS + (bU and 66 or 40)), 1, 0), Text = bK.Name or 'Groupbox',
                TextSize = 13, FontFace = D.Bold, ZIndex = 2, Parent = bQ
            }
        )
        local bY = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                LayoutOrder = 2, Parent = bP
            }
        )
        local bZ = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, ClipsDescendants = true, LayoutOrder = 3, Parent = bP
            }
        )
        local b_ = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = bZ
            }
        )
        k._space(al(b_, 0, 0, 6, 8), {0, 0, 6, 8})
        k._space(
            ai(
                'UIListLayout',
                {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b_}
            ), 2
        )
        local b0 = setmetatable(
            {
                Name = bK.Name or 'Groupbox', Window = bM, Parent = self, List = b_, Frame = bP,
                _frame = bP, _order = 0, _groupbox = true, _metrics = P.Row, _items = {}
            }, aS
        )
        table.insert(self._groupboxes, b0)
        local b1 = false
        local b2 = 0
        local function b3(b4, b5)
            b4 = b4 == true
            if b4 == b1 then
                return
            end
            b1 = b4
            b2 += 1
            local b6 = b2
            local b7 = b5 and 0 or 0.32
            if b4 then
                for b8, b9 in ipairs(b0._items) do
                    if b9._onHide then
                        b9._onHide()
                    end
                    if b9.Open and type(b9.SetOpen) == 'function' then
                        b9:SetOpen(false)
                    end
                end
            end
            bM._controlsDirty = true
            local b8 = bM.Scale.Scale
            if b4 then
                bZ.AutomaticSize = Enum.AutomaticSize.None
                bZ.Size = UDim2.new(1, 0, 0, bZ.AbsoluteSize.Y / b8)
                ah(bZ, {Size = UDim2.new(1, 0, 0, 0)}, b7, Enum.EasingStyle.Quint)
            else
                ah(
                    bZ, {Size = UDim2.new(1, 0, 0, b_.AbsoluteSize.Y / b8)}, b7,
                    Enum.EasingStyle.Quint
                )
                local function b9()
                    if b2 == b6 and not b1 then
                        bZ.AutomaticSize = Enum.AutomaticSize.Y
                        bZ.Size = UDim2.new(1, 0, 0, 0)
                    end
                end
                if b7 > 0 then
                    task.delay(b7, b9)
                else
                    b9()
                end
            end
            local b9 = b5 and 0 or 0.3
            if b4 then
                local function ca()
                    if b2 == b6 and b1 then
                        bY.Visible = false
                        bR.Visible = false
                    end
                end
                if b7 > 0 then
                    task.delay(b7, ca)
                else
                    ca()
                end
            else
                bY.Visible = true
                bR.Visible = true
            end
            ah(bT, {Rotation = b4 and -90 or 0}, b9, Enum.EasingStyle.Quint)
        end
        local function b4(b5)
            local b6 = b5 and 0.15 or 0.25
            ah(bT, {ImageColor3 = b5 and z.Text or z.Muted}, b6)
            if bW and not E then
                ah(bW, {ImageTransparency = b5 and 0 or 0.45}, b6)
            end
        end
        bQ.MouseEnter:Connect(
            function()
                b4(true)
            end
        )
        bQ.MouseLeave:Connect(
            function()
                b4(false)
            end
        )
        local b5 = ay(
            bQ,
            function()
                return bP:FindFirstAncestorWhichIsA('ScrollingFrame')
            end
        )
        local b6, b7 = false, 0
        local b8, b9, ca, cb, cc
        local cd, ce, cf, cg = nil, nil, false, false
        local ch = false
        local function ci()
            return math.max(bM.Scale.Scale, 0.05)
        end
        local function cj(ck)
            return (ck - bM._popLayer.AbsolutePosition) / ci()
        end
        local function ck(cl, cm, cn)
            local co = bM._popLayer.AbsoluteSize / ci()
            local cp = 8
            local cq = math.clamp(cl.X, cm / 2 + cp, math.max(co.X - cm / 2 - cp, cm / 2 + cp))
            local cr = math.clamp(cl.Y, cp, math.max(co.Y - math.min(cn, 120) - cp, cp))
            return Vector2.new(cq, cr)
        end
        local function cl()
            for cm, cn in ipairs(b0._items) do
                if cn._onHide then
                    cn._onHide()
                end
                if cn.Open and type(cn.SetOpen) == 'function' then
                    cn:SetOpen(false)
                end
            end
        end
        local function cm(cn)
            if bW then
                aq(bW, cn and 'minimize-2' or 'picture-in-picture-2')
            end
        end
        local function cn()
            if b6 or not bU or not bP.Parent or b0._destroyed then
                return
            end
            if b0._settleDock then
                b0._settleDock()
            end
            local co = bM:_popoutLayer()
            b6 = true
            b0._popped = true
            b7 += 1
            local cp = b7
            cl()
            bM:_closePopups()
            local cq = ci()
            local cr = bP.Parent
            local cs = cj(bP.AbsolutePosition)
            local ct = bP.AbsoluteSize.X / cq
            local cu = bP.AbsoluteSize.Y / cq
            cb = ai(
                'TextButton',
                {
                    Size = UDim2.new(1, 0, 0, cu), BackgroundColor3 = z.Surface2,
                    BackgroundTransparency = 0.6, BorderSizePixel = 0, Text = '',
                    AutoButtonColor = false, ClipsDescendants = true, LayoutOrder = bP.LayoutOrder,
                    Parent = cr
                }
            )
            cb:SetAttribute('NoDrag', true)
            aj(cb, UDim.new(0, 10))
            ak(cb, z.Stroke, 1).Transparency = 0.3
            local cv = am(
                {
                    Size = UDim2.new(1, -24, 0, 40), Position = UDim2.fromOffset(12, 0),
                    Text = k._rich(b0.Name) .. '<font transparency="0.4">  \u{b7}  popped out, click to dock</font>',
                    TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextXAlignment = Enum.TextXAlignment.Center, RichText = true,
                    TextTransparency = 1, Parent = cb
                }
            )
            local cw = cb
            cb.MouseEnter:Connect(
                function()
                    ah(cw, {BackgroundTransparency = 0.35}, 0.15)
                end
            )
            cb.MouseLeave:Connect(
                function()
                    ah(cw, {BackgroundTransparency = 0.6}, 0.25)
                end
            )
            cb.MouseButton1Click:Connect(
                function()
                    if cb == cw then
                        b0:Dock()
                    end
                end
            )
            ah(cb, {Size = UDim2.new(1, 0, 0, 40)}, 0.42, Enum.EasingStyle.Quint)
            ah(cv, {TextTransparency = 0}, 0.3)
            cb.Visible = bP.Visible
            b8 = ai(
                'Frame',
                {
                    Name = 'PopOut', AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromOffset(cs.X + ct / 2, cs.Y),
                    Size = UDim2.fromOffset(ct, cu), BackgroundTransparency = 1, Parent = co
                }
            )
            b8:SetAttribute('NoDrag', true)
            b9 = ai('UIScale', {Parent = b8})
            ca = ai(
                'ImageLabel',
                {
                    Position = UDim2.fromOffset(-24, -18), Size = UDim2.new(1, 48, 1, 44),
                    BackgroundTransparency = 1, Image = A.Shadow, ImageColor3 = Color3.new(0, 0, 0),
                    ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0, Parent = b8
                }
            )
            table.insert(bM._popPanels, b8)
            bP.Parent = b8
            bM._controlsDirty = true
            cm(true)
            local cx = ck(b0._popSpot or Vector2.new(cs.X + ct / 2 + 22, cs.Y - 14), ct, cu)
            ch = true
            b9.Scale = 0.97
            ah(b8, {Position = UDim2.fromOffset(cx.X, cx.Y)}, 0.5, Enum.EasingStyle.Quint)
            ah(b9, {Scale = 1}, 0.55, Enum.EasingStyle.Back)
            ah(ca, {ImageTransparency = 0.35}, 0.4)
            task.delay(
                0.5,
                function()
                    if b7 == cp then
                        ch = false
                    end
                end
            )
            local cy = b8
            cc = bM:_listen(
                'Render',
                function()
                    if b8 ~= cy or not cy.Parent then
                        return
                    end
                    local cz = bP.AbsoluteSize.Y / ci()
                    if math.abs(cy.Size.Y.Offset - cz) > 0.5 then
                        cy.Size = UDim2.fromOffset(cy.Size.X.Offset, cz)
                    end
                    cy.Visible = bP.Visible
                    if cb then
                        cb.Visible = bP.Visible
                    end
                    if not ch and not cd then
                        local cA = Vector2.new(cy.Position.X.Offset, cy.Position.Y.Offset)
                        local cB = ck(cA, cy.Size.X.Offset, cz)
                        if (cB - cA).Magnitude > 0.5 then
                            cy.Position = UDim2.fromOffset(cB.X, cB.Y)
                        end
                    end
                end
            )
        end
        local function co(cp)
            if not b6 then
                return
            end
            b6 = false
            b0._popped = false
            b7 += 1
            cd, cf, cg = nil, false, false
            cl()
            bM:_closePopups()
            local cq, cr, cs, ct, cu = b8, cb, cc, b9, ca
            b8, cb, cc = nil, nil, nil
            cm(false)
            b0._popSpot = Vector2.new(cq.Position.X.Offset, cq.Position.Y.Offset)
            local cv = false
            local function cw()
                if cv then
                    return
                end
                cv = true
                if b0._settleDock == cw then
                    b0._settleDock = nil
                end
                if cs then
                    cs()
                end
                local cx = table.find(bM._popPanels, cq)
                if cx then
                    table.remove(bM._popPanels, cx)
                end
                if bP.Parent == cq then
                    if cr and cr.Parent and not b0._destroyed then
                        bP.Parent = cr.Parent
                        bP.LayoutOrder = cr.LayoutOrder
                    end
                end
                if cr then
                    cr:Destroy()
                end
                if bP.Parent ~= cq then
                    cq:Destroy()
                end
                ch = false
                bM._controlsDirty = true
            end
            b0._settleDock = cw
            local cx = not cp and cr and cr.Parent and bM.Root.Visible and bP.Visible and cr.AbsoluteSize.X > 0 and a3(
                cr, bM.Body, cr.AbsolutePosition + cr.AbsoluteSize / 2
            )
            if not cx then
                cw()
                return
            end
            ch = true
            local cy = ci()
            local cz = bP.AbsoluteSize.Y / cy
            local cA = cr.AbsoluteSize.X / cy
            ah(cr, {Size = UDim2.new(1, 0, 0, cz)}, 0.36, Enum.EasingStyle.Quint)
            local cB = cr:FindFirstChildWhichIsA('TextLabel')
            if cB then
                ah(cB, {TextTransparency = 1}, 0.12)
            end
            local cC = cj(cr.AbsolutePosition)
            ah(
                cq,
                {Position = UDim2.fromOffset(cC.X + cA / 2, cC.Y), Size = UDim2.fromOffset(cA, cz)},
                0.36, Enum.EasingStyle.Quint
            )
            ah(ct, {Scale = 1}, 0.2)
            ah(cu, {ImageTransparency = 1}, 0.3)
            task.delay(0.37, cw)
        end
        bQ.InputBegan:Connect(
            function(cp)
                if not b6 or not aw(cp) or not b8 then
                    return
                end
                cd = Vector2.new(cp.Position.X, cp.Position.Y)
                ce = Vector2.new(b8.Position.X.Offset, b8.Position.Y.Offset)
                cf = false
                cg = false
            end
        )
        bM:_listen(
            'Changed',
            function(cp)
                if not cd or not b8 or not aA(cp) then
                    return
                end
                local cq = Vector2.new(cp.Position.X, cp.Position.Y) - cd
                if not cf then
                    if cq.Magnitude < (E and 8 or 5) then
                        return
                    end
                    cf, cg = true, true
                    ch = false
                    cl()
                    bM:_closePopups()
                    ah(b9, {Scale = 1.025}, 0.18, Enum.EasingStyle.Quint)
                    ah(ca, {ImageTransparency = 0.15}, 0.18)
                end
                local cr = ck(ce + cq / ci(), b8.Size.X.Offset, b8.Size.Y.Offset)
                b8.Position = UDim2.fromOffset(cr.X, cr.Y)
            end, b0
        )
        bM:_listen(
            'Ended',
            function(cp)
                if not cd or not aw(cp) then
                    return
                end
                cd = nil
                if cf and b8 then
                    cf = false
                    ah(b9, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
                    ah(ca, {ImageTransparency = 0.35}, 0.3)
                    b0._popSpot = Vector2.new(b8.Position.X.Offset, b8.Position.Y.Offset)
                end
            end, b0
        )
        if bV then
            bV.MouseEnter:Connect(
                function()
                    ah(bV, {BackgroundTransparency = 0}, 0.15)
                    ah(bW, {ImageColor3 = z.Text}, 0.15)
                end
            )
            bV.MouseLeave:Connect(
                function()
                    ah(bV, {BackgroundTransparency = 1}, 0.25)
                    ah(bW, {ImageColor3 = z.Muted}, 0.25)
                end
            )
            bV.MouseButton1Click:Connect(
                function()
                    if b6 then
                        co()
                    else
                        cn()
                    end
                end
            )
        end
        bQ.MouseButton1Click:Connect(
            function()
                if cg then
                    cg = false
                    return
                end
                if b5() then
                    b3(not b1)
                end
            end
        )
        function b0:PopOut()
            cn()
        end
        function b0:Dock()
            co()
        end
        function b0:IsPoppedOut()
            return b6
        end
        function b0:SetCollapsed(cp)
            b3(cp)
        end
        function b0:Collapse()
            b3(true)
        end
        function b0:Expand()
            b3(false)
        end
        function b0:IsCollapsed()
            return b1
        end
        function b0:SetTitle(cp)
            b0.Name = tostring(cp)
            bX.Text = b0.Name
        end
        b0._userVisible = bK.Visible ~= false
        function b0:IsVisible()
            return b0._userVisible
        end
        function b0:SetVisible(cp)
            cp = cp and true or false
            if cp == b0._userVisible then
                return
            end
            b0._userVisible = cp
            if not cp then
                for cq, cr in ipairs(b0._items) do
                    if cr._onHide then
                        cr._onHide()
                    end
                    if cr.Open and type(cr.SetOpen) == 'function' then
                        cr:SetOpen(false)
                    end
                end
            end
            bP.Visible = cp
            bM._controlsDirty = true
        end
        if not b0._userVisible then
            bP.Visible = false
        end
        function b0:Destroy()
            for cp = #b0._items, 1, -1 do
                local cq = b0._items[cp]
                if type(cq.Destroy) == 'function' then
                    cq:Destroy()
                end
            end
            local cp = b0.Parent
            local cq = table.find(cp._groupboxes, b0)
            if cq then
                table.remove(cp._groupboxes, cq)
            end
            bN.Counts[bO] = math.max(bN.Counts[bO] - 1, 0)
            co(true)
            b0._destroyed = true
            bM._controlsDirty = true
            bP:Destroy()
        end
        if bK.Collapsed then
            b3(true, true)
        end
        if bK.PoppedOut then
            task.defer(cn)
        end
        return b0
    end
    local function bK(bL)
        return function(bM, bN, bO)
            bN = l(bN, {Title = 'Name'})
            bN.Side = bL
            return bM:Groupbox(bN, bO)
        end
    end
    aS.CreateGroupbox = aS.Groupbox
    aS.AddGroupbox = aS.Groupbox
    aS.AddLeftGroupbox = bK('Left')
    aS.AddRightGroupbox = bK('Right')
    function aS:ButtonRow(bL)
        local bM = type(bL) == 'table' and (bL.Buttons or bL) or {}
        local bN = aM(self).Compact
        local bO = E and 34 or 30
        local bP = aO(self, 'Frame', bO + (bN and 4 or 14), {})
        local bQ = bN and 14 or 7
        local bR = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(bQ, bN and 2 or 7), Size = UDim2.new(1, -bQ * 2, 0, bO),
                BackgroundTransparency = 1, Parent = bP
            }
        )
        local bS = math.max(#bM, 1)
        local bT = {Buttons = {}}
        local bU = {}
        for bV, bW in ipairs(bM) do
            if type(bW) == 'string' then
                bW = {Name = bW}
            end
            local bX = bW.Name or bW.Title or 'Button'
            table.insert(bU, bX)
            local bY, bZ = bF(
                bR, bX,
                {
                    Position = UDim2.new((bV - 1) / bS, (bV - 1) * 6 / bS, 0, 0),
                    Size = UDim2.new(1 / bS, -6 * (bS - 1) / bS, 1, 0)
                },
                function()
                    aJ(bW.Callback)
                end
            )
            bZ.TextSize = 13
            if bW.Style == 'Primary' then
                ah(bY, {BackgroundColor3 = z.Accent, BackgroundTransparency = 0.12}, 0)
                ah(bZ, {TextColor3 = z.AccentDark}, 0)
            elseif bW.Style == 'Danger' then
                ah(bZ, {TextColor3 = z.Error}, 0)
            end
            bT.Buttons[bV] = {Button = bY, Label = bZ}
        end
        function bT:SetText(bV, bW)
            local bX = bT.Buttons[bV]
            if bX then
                bX.Label.Text = tostring(bW)
            end
        end
        return m(
            self,
            {Name = table.concat(bU, ' '), Visible = not (type(bL) == 'table' and bL.Visible == false)},
            bT, bP, 'ButtonRow'
        )
    end
    local function bL(bM, bN, bO, bP)
        local bQ = E and 34 or 30
        local bR = aO(bM, 'Frame', bQ + 4, {})
        local bS = aM(bM).Compact and 14 or 7
        local bT
        local bU = bO and bF(
            bR, bO,
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -bS, 0, 2),
                Size = UDim2.fromOffset(0, bQ), AutomaticSize = Enum.AutomaticSize.X
            },
            function()
                aJ(bP, bT.Text)
            end
        )
        local bV = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(bS, 2),
                Size = UDim2.new(1, -(bS * 2 + (bU and 70 or 0)), 0, bQ),
                BackgroundColor3 = z.Surface, BorderSizePixel = 0, Parent = bR
            }
        )
        aj(bV, UDim.new(0, 6))
        local bW = ak(bV)
        bT = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 1, 0),
                BackgroundTransparency = 1, Text = '', PlaceholderText = bN,
                PlaceholderColor3 = z.Muted, TextColor3 = z.Text, TextSize = 13,
                FontFace = D.Regular, TextXAlignment = Enum.TextXAlignment.Center,
                TextTruncate = Enum.TextTruncate.AtEnd, ClearTextOnFocus = false, Parent = bV
            }
        )
        bT.Focused:Connect(
            function()
                ah(bW, {Color = z.StrokeHover}, 0.15)
            end
        )
        bT.FocusLost:Connect(
            function(bX)
                ah(bW, {Color = z.Stroke}, 0.2)
                if bX and bT.Text ~= '' then
                    aJ(bP, bT.Text)
                end
            end
        )
        if bU then
            local function bX()
                local bY = bU.AbsoluteSize.X / bM.Window.Scale.Scale
                bV.Size = UDim2.new(1, -(bS * 2 + bY + 6), 0, bQ)
            end
            bU:GetPropertyChangedSignal('AbsoluteSize'):Connect(bX)
            task.defer(bX)
        end
        return m(
            bM, {Name = bN},
            {
                Get = function()
                    return bT.Text
                end,
                Set = function(bX, bY)
                    bT.Text = tostring(bY or '')
                end
            }, bR, 'ActionInput'
        )
    end
    local function bM(bN)
        return (tostring(bN or ''):match('^%s*(.-)%s*$'))
    end
    local function bN(bO, bP, bQ, bR)
        if bO._groupbox then
            return bO
        end
        local bS = bO:Groupbox({Name = bP.Name or bQ, Icon = bP.Icon or bR, Side = bP.Side})
        bS._manager = true
        return bS
    end
    function aS:ConfigManager(bO)
        bO = l(bO, {Title = 'Name'})
        local bP = bN(self, bO, 'Configs', 'folder')
        local bQ = self.Window
        local bR = {}
        local bS, bT, bU
        local function bV(bW, bX, bY)
            bQ:Notify({Title = bX, Content = bY, Type = bW and 'Success' or 'Error', Duration = 3})
        end
        local function bW()
            bT:Set(
                ('loaded: %s   |   autoload: %s'):format(
                    bQ.LoadedConfig or 'none', bQ:GetAutoload() or 'none'
                )
            )
        end
        local function bX()
            local bY = bS:Get()
            if not bY then
                bV(false, 'No config selected', 'Pick one from the list first')
            end
            return bY
        end
        local bY = bL(
            bP, bO.Placeholder or 'config name', nil,
            function(bY)
                bR:Create(bY)
            end
        )
        local bZ = bQ:ListConfigs()
        local b_ = bQ.LoadedConfig or bQ:GetAutoload()
        bS = bP:Dropdown(
            {
                Stacked = true, Options = bZ, Default = table.find(bZ, b_) and b_ or nil,
                EmptyText = '--', NoneText = '--'
            }
        )
        bP:ButtonRow(
            {
                {
                    Name = 'Create',
                    Callback = function()
                        bR:Create(bY:Get())
                    end
                },
                {
                    Name = 'Save',
                    Callback = function()
                        bR:Save()
                    end
                }
            }
        )
        bP:ButtonRow(
            {
                {
                    Name = 'Load',
                    Callback = function()
                        bR:Load()
                    end
                },
                {
                    Name = 'Delete', Style = 'Danger',
                    Callback = function()
                        bR:Delete()
                    end
                }
            }
        )
        bP:ButtonRow(
            {
                {
                    Name = 'Set autoload',
                    Callback = function()
                        bR:SetAutoload()
                    end
                },
                {
                    Name = 'Clear autoload',
                    Callback = function()
                        bR:ClearAutoload()
                    end
                }
            }
        )
        bP:ButtonRow(
            {
                {
                    Name = 'Rename',
                    Callback = function()
                        bR:Rename(nil, bY:Get())
                    end
                },
                {
                    Name = 'Reset', Style = 'Danger',
                    Callback = function()
                        bR:Reset()
                    end
                }
            }
        )
        bT = bP:Label('loaded: none   |   autoload: none')
        bU = bP:Dropdown(
            {
                Name = 'Autoload mode', Stacked = true, Options = {'All accounts', 'This account'},
                Default = bQ:GetAutoloadMode() == 'Account' and 'This account' or 'All accounts',
                AllowNone = false,
                Callback = function(b0)
                    bR:SetAutoloadMode(b0 == 'This account' and 'Account' or 'Global')
                end
            }
        )
        bP:Button(
            {
                Name = 'Refresh list',
                Callback = function()
                    bR:Refresh()
                end
            }
        )
        bP:Divider({Text = 'share'})
        bP:Button(
            {
                Name = 'Copy code',
                Callback = function()
                    bR:Export()
                end
            }
        )
        local b0 = bL(
            bP, 'paste a config code...', nil,
            function(b0)
                bR:Import(b0)
            end
        )
        bP:Button(
            {
                Name = 'Import code',
                Callback = function()
                    bR:Import(b0:Get())
                end
            }
        )
        function bR:Refresh()
            local b1 = bQ:ListConfigs()
            local b2 = bS:Get()
            bS:Refresh(b1, true)
            if b2 and not table.find(b1, b2) then
                bS:Set(
                    bQ.LoadedConfig and table.find(b1, bQ.LoadedConfig) and bQ.LoadedConfig or nil,
                    true
                )
            end
            bW()
        end
        local function b1(b2)
            bR:Refresh()
            bS:Set(b2, true)
        end
        function bR:Create(b2)
            b2 = bM(b2)
            if b2 == '' then
                bV(false, 'Name the config', 'Type a name before creating it')
                return
            end
            if not bi(b2) then
                bV(false, 'Invalid name', 'Names cannot contain \\ / : * ? " < > |')
                return
            end
            local b3, b4 = bQ:SaveConfig(b2)
            if b3 then
                bQ.LoadedConfig = b2
                bY:Set('')
                b1(b2)
            end
            bV(b3, b3 and 'Config created' or 'Create failed', b3 and b2 or tostring(b4))
        end
        function bR:Save(b2)
            b2 = b2 or bS:Get()
            if not b2 then
                local b3 = bM(bY:Get())
                if b3 == '' then
                    bV(false, 'No config selected', 'Pick one from the list or type a name')
                    return
                end
                return bR:Create(b3)
            end
            local b3, b4 = bQ:SaveConfig(b2)
            if b3 then
                bQ.LoadedConfig = b2
                bW()
            end
            bV(b3, b3 and 'Config saved' or 'Save failed', b3 and b2 or tostring(b4))
        end
        function bR:Load(b2)
            b2 = b2 or bX()
            if not b2 then
                return
            end
            local b3, b4 = bQ:LoadConfig(b2)
            bV(b3, b3 and 'Config loaded' or 'Load failed', b3 and b2 or tostring(b4))
        end
        function bR:Delete(b2)
            b2 = b2 or bX()
            if not b2 then
                return
            end
            bQ:Confirm(
                {
                    Title = 'Delete config',
                    Content = 'Remove ' .. b2 .. '? This cannot be undone.', Icon = 'trash-2',
                    ConfirmText = 'Delete',
                    Callback = function()
                        local b3, b4 = bQ:DeleteConfig(b2)
                        if b3 then
                            if bQ:GetAutoload('Account') == b2 then
                                bQ:SetAutoload(nil, 'Account')
                            end
                            if bQ:GetAutoload('Global') == b2 then
                                bQ:SetAutoload(nil, 'Global')
                            end
                            bS:Set(nil, true)
                        end
                        bR:Refresh()
                        bV(
                            b3, b3 and 'Config deleted' or 'Delete failed',
                            b3 and b2 or tostring(b4)
                        )
                    end
                }
            )
        end
        function bR:Rename(b2, b3)
            b2 = b2 or bX()
            if not b2 then
                return
            end
            b3 = bM(b3)
            if b3 == '' then
                bV(false, 'Name the config', 'Type the new name in the name box')
                return
            end
            if not bi(b3) then
                bV(false, 'Invalid name', 'Names cannot contain \\ / : * ? " < > |')
                return
            end
            local b4, b5 = bQ:RenameConfig(b2, b3)
            if b4 then
                bY:Set('')
                b1(b3)
            end
            bV(
                b4, b4 and 'Config renamed' or 'Rename failed',
                b4 and (b2 .. ' -> ' .. b3) or tostring(b5)
            )
        end
        function bR:Reset()
            bQ:Confirm(
                {
                    Title = 'Reset settings',
                    Content = [[Put every setting back to its default and delete this script's folder? Saved configs, themes and autoload are removed for good.]],
                    Icon = 'rotate-ccw', ConfirmText = 'Reset',
                    Callback = function()
                        bQ:ResetConfig()
                        local b2 = bQ:ClearWorkspace()
                        bQ:_applyDefaultTheme()
                        bS:Set(nil, true)
                        bR:Refresh()
                        bU:Set('All accounts', true)
                        bV(
                            b2, b2 and 'Settings reset' or 'Reset incomplete',
                            b2 and 'Everything is back to its default' or 'Some files in ' .. bQ.ConfigFolder .. ' could not be deleted'
                        )
                    end
                }
            )
        end
        function bR:SetAutoload(b2)
            b2 = b2 or bX()
            if not b2 then
                return
            end
            local b3, b4 = bQ:SetAutoload(b2)
            bV(b3, b3 and 'Autoload set' or 'Autoload failed', b3 and b2 or tostring(b4))
        end
        function bR:ClearAutoload()
            local b2 = bQ:GetAutoload()
            if not b2 then
                bV(false, 'No autoload', 'Nothing is set to autoload')
                return
            end
            local b3, b4 = bQ:SetAutoload(nil)
            bV(b3, b3 and 'Autoload cleared' or 'Clear failed', b3 and b2 or tostring(b4))
        end
        function bR:ToggleAutoload(b2)
            b2 = b2 or bX()
            if not b2 then
                return
            end
            if bQ:GetAutoload() == b2 then
                bR:ClearAutoload()
            else
                bR:SetAutoload(b2)
            end
        end
        function bR:SetAutoloadMode(b2)
            local b3, b4 = bQ:SetAutoloadMode(b2)
            local b5 = b2 == 'Account' and 'This account' or 'All accounts'
            if bU:Get() ~= b5 then
                bU:Set(b5, true)
            end
            bV(
                b3 ~= false, b3 ~= false and 'Autoload mode' or 'Mode change failed',
                b3 ~= false and b5 or tostring(b4)
            )
        end
        function bR:Export(b2)
            local b3, b4 = bQ:ExportConfig(b2)
            if not b3 then
                bV(false, 'Export failed', tostring(b4))
                return nil
            end
            bQ:CopyToClipboard(b3, 'Config code')
            return b3
        end
        function bR:Import(b2)
            b2 = bM(b2)
            if b2 == '' then
                bV(false, 'Nothing to import', 'Paste a config code first')
                return
            end
            local b3, b4 = bQ:DecodeConfig(b2)
            if not b3 then
                bV(false, 'Import failed', 'Invalid config code')
                return
            end
            local b5 = bM(bY:Get())
            if b5 == '' then
                b5 = nil
                if bi(b4.Name) then
                    b5 = b4.Name
                    local b6 = 2
                    while bQ:ConfigExists(b5) do
                        b5 = ('%s (%d)'):format(b4.Name, b6)
                        b6 += 1
                    end
                end
            elseif not bi(b5) then
                bV(false, 'Invalid name', 'Names cannot contain \\ / : * ? " < > |')
                return
            end
            local function b6()
                local b7, b8 = bQ:ImportConfig(b2, b5, true)
                if b7 then
                    b0:Set('')
                    if b5 then
                        bY:Set('')
                        b1(b5)
                    end
                end
                bV(
                    b7, b7 and 'Config imported' or 'Import failed',
                    b7 and (b5 or 'Applied to current settings') or tostring(b8)
                )
            end
            if b4.Folder and b4.Folder ~= bQ.ConfigFolder then
                bQ:Confirm(
                    {
                        Title = 'Different script',
                        Content = ([[This config was made for %s. Import it anyway? Only matching settings are applied.]]):format(
                            b4.Folder
                        ), Icon = 'triangle-alert', ConfirmText = 'Import', Callback = b6
                    }
                )
                return
            end
            b6()
        end
        local b2 = bQ:OnConfigChanged(
            function()
                bR:Refresh()
                if bQ.LoadedConfig and bS:Get() == nil then
                    bS:Set(bQ.LoadedConfig, true)
                end
            end
        )
        bT._listeners = bT._listeners or {}
        table.insert(bT._listeners, b2)
        bW()
        return bR
    end
    local bO = {
        'Midnight', 'Nebula', 'Synthwave', 'Sakura', 'Velvet', 'Rose', 'Crimson', 'Sunset', 'Amber',
        'Gold', 'Cyber', 'Toxic', 'Matcha', 'Emerald', 'Aurora', 'Ocean', 'Frost', 'Abyss', 'Mono',
        'Halloween', 'Haunted', 'Christmas', 'Valentine', 'Lunar', 'Tropical', 'Dracula', 'Coffee'
    }
    local function bP()
        local bQ, bR = {}, {}
        for bS, bT in ipairs(bO) do
            if k.ThemePresets[bT] then
                table.insert(bQ, bT)
                bR[bT] = true
            end
        end
        local bS = {}
        for bT in pairs(k.ThemePresets) do
            if not bR[bT] then
                table.insert(bS, bT)
            end
        end
        table.sort(bS)
        for bT, bU in ipairs(bS) do
            table.insert(bQ, bU)
        end
        return bQ
    end
    function aS:ThemeManager(bQ)
        bQ = l(bQ, {Title = 'Name'})
        local bR = bN(self, bQ, 'Themes', 'palette')
        local bS = self.Window
        local bT = {}
        local bU, bV, bW, bX
        local bY, bZ, b_, b0, b1, b2
        local b3, b4, b5, b6
        local b7, b8, b9, ca
        local function cb(cc, cd, ce)
            bS:Notify({Title = cd, Content = ce, Type = cc and 'Success' or 'Error', Duration = 3})
        end
        local function cc()
            local cd = bS:GetDefaultTheme()
            bV:Set('Default theme: ' .. (cd or 'none'))
            local ce = bU:Get() or bX:Get()
            bW:SetText(2, (ce and ce == cd) and 'Clear Default' or 'Set Default')
        end
        local function cd()
            local ce = bU:Get()
            if not ce then
                cb(false, 'No theme selected', 'Pick one from the list first')
            end
            return ce
        end
        bX = bR:Dropdown(
            {
                Name = 'Preset', Options = bP(),
                Default = k.ThemePresets[k.ThemeName or ''] and k.ThemeName or nil,
                NoneText = 'custom', AllowNone = false,
                Callback = function(ce)
                    if ce then
                        k:SetTheme(ce)
                        bU:Set(nil, true)
                        cc()
                    end
                end
            }
        )
        local ce = {
            None = 'None', Snow = 'Snow', Rain = 'Rain', Ember = 'Hell Fire', Sakura = 'Sakura',
            Fireflies = 'Fireflies', Matrix = 'Matrix'
        }
        if bS._backdrop and bQ.Weather ~= false then
            bY = bR:Dropdown(
                {
                    Name = 'Weather',
                    Options = {'Snow', 'Rain', 'Hell Fire', 'Sakura', 'Fireflies', 'Matrix', 'None'},
                    Default = ce[bS.Weather] or 'None', AllowNone = false,
                    Callback = function(cf)
                        if cf then
                            bS:SetWeather(cf)
                        end
                    end
                }
            )
        end
        if bS._backdrop and bQ.Weather ~= false then
            bZ = bR:Dropdown(
                {
                    Name = 'Weather Mode', Options = {'Screen', 'UI'}, Default = bS.WeatherMode,
                    AllowNone = false,
                    Callback = function(cf)
                        if cf then
                            bS:SetWeatherMode(cf)
                        end
                    end
                }
            )
        end
        if bS._backdrop and bQ.Dim ~= false then
            b_ = bR:Toggle(
                {
                    Name = 'Dim', Default = bS._backdropDim,
                    Callback = function(cf)
                        bS:SetDim(cf)
                    end
                }
            )
        end
        if bQ.Transparent ~= false then
            b0 = bR:Toggle(
                {
                    Name = 'Transparent', Default = bS.Transparent == true,
                    Callback = function(cf)
                        bS:SetTransparent(cf)
                    end
                }
            )
        end
        if bQ.DragSkeleton ~= false and bQ.DragStyle ~= false then
            b1 = bR:Dropdown(
                {
                    Name = 'Drag Style', Options = k.DragStyles, Default = bS.DragStyle,
                    AllowNone = false,
                    Callback = function(cf)
                        if cf then
                            bS:SetDragStyle(cf)
                        end
                    end
                }
            )
        end
        if bQ.IslandStyle ~= false then
            b2 = bR:Dropdown(
                {
                    Name = 'Dynamic Island', Options = k.IslandStyles, Default = bS.IslandStyle,
                    AllowNone = false,
                    Callback = function(cf)
                        if cf then
                            bS:SetIslandStyle(cf)
                        end
                    end
                }
            )
        end
        if bQ.AdaptiveSize ~= false then
            b9 = bR:Toggle(
                {
                    Name = 'Adaptive Size', Default = bS:GetAdaptiveSize(),
                    Callback = function(cf)
                        bS:SetAdaptiveSize(cf)
                    end
                }
            )
        end
        if bQ.Scale ~= false then
            b7 = bR:Slider(
                {
                    Name = 'UI Scale', Min = 60, Max = 150, Increment = 5,
                    Default = math.floor(bS:GetUIScale() * 100 + 0.5), Suffix = '%',
                    Callback = function(cf)
                        if not (b7 and b7.Dragging) then
                            bS:SetUIScale(cf / 100)
                        end
                    end,
                    OnRelease = function(cf)
                        bS:SetUIScale(cf / 100)
                    end
                }
            )
        end
        if bQ.Density ~= false then
            b8 = bR:Dropdown(
                {
                    Name = 'Density', Options = {'Compact', 'Default', 'Comfortable'},
                    Default = k.Density, AllowNone = false,
                    Callback = function(cf)
                        if cf then
                            k:SetDensity(cf)
                        end
                    end
                }
            )
        end
        if bQ.CornerRadius ~= false then
            ca = bR:Slider(
                {
                    Name = 'Corner Radius', Min = 0, Max = 20, Increment = 1,
                    Default = k:GetCornerRadius(), Suffix = 'px',
                    Callback = function(cf)
                        k:SetCornerRadius(cf)
                    end
                }
            )
        end
        if bQ.Background ~= false then
            b6 = function(cf)
                if cf == nil or cf == '' then
                    return 'None'
                end
                return table.find(bS:ListBackgrounds(), cf) and cf or nil
            end
            local function cf(cg, ch)
                task.spawn(
                    function()
                        local ci, cj = bS:SetBackground(cg)
                        if ci and not ch then
                            b3:Set(b6(bS.Background), true)
                        elseif not ci and cj ~= 'replaced by a newer background' then
                            cb(false, 'Background failed', tostring(cj))
                        end
                    end
                )
            end
            local cg = bS:ListBackgrounds()
            table.insert(cg, 1, 'None')
            b3 = bR:Dropdown(
                {
                    Name = 'Background', Options = cg, Default = b6(bS.Background),
                    NoneText = 'custom', AllowNone = false,
                    Callback = function(ch)
                        if ch then
                            cf(ch, true)
                        end
                    end
                }
            )
            b4 = bL(
                bR, 'image id or url', 'Set',
                function(ch)
                    ch = bM(ch)
                    if ch == '' then
                        cb(false, 'No image', 'Paste an image id or link first')
                        return
                    end
                    cf(ch)
                end
            )
            b5 = bR:Slider(
                {
                    Name = 'Background Opacity', Min = 0, Max = 100,
                    Default = math.floor((1 - bS.BackgroundTransparency) * 100 + 0.5), Suffix = '%',
                    Callback = function(ch)
                        bS:SetBackgroundTransparency(1 - ch / 100)
                    end
                }
            )
        end
        local cf = bL(
            bR, bQ.Placeholder or 'theme name', 'Create',
            function(cf)
                bT:Create(cf)
            end
        )
        bU = bR:Dropdown(
            {
                Name = 'Theme', Options = bS:ListThemes(),
                Default = (function()
                    local cg = bS:GetDefaultTheme()
                    return cg and not k.ThemePresets[cg] and cg or nil
                end)(), EmptyText = 'no themes', NoneText = 'select',
                Callback = function()
                    cc()
                end
            }
        )
        bR:ButtonRow(
            {
                {
                    Name = 'Save',
                    Callback = function()
                        bT:Save()
                    end
                },
                {
                    Name = 'Load',
                    Callback = function()
                        bT:Load()
                    end
                }
            }
        )
        bW = bR:ButtonRow(
            {
                {
                    Name = 'Delete',
                    Callback = function()
                        bT:Delete()
                    end
                },
                {
                    Name = 'Set Default',
                    Callback = function()
                        bT:ToggleDefault()
                    end
                }
            }
        )
        bV = bR:Label('Default theme: none')
        function bT:Refresh()
            bU:Refresh(bS:ListThemes(), true)
            if b3 then
                local cg = bS:ListBackgrounds()
                table.insert(cg, 1, 'None')
                b3:Refresh(cg, true, true)
            end
            cc()
        end
        function bT:Create(cg)
            cg = bM(cg)
            if cg == '' then
                cb(false, 'Name the theme', 'Type a name before creating it')
                return
            end
            if k.ThemePresets[cg] then
                cb(false, 'Name taken', cg .. ' is a built-in preset')
                return
            end
            local ch, ci = bS:SaveTheme(cg)
            bT:Refresh()
            if ch then
                bU:Set(cg, true)
                cf:Set('')
                cc()
            end
            cb(ch, ch and 'Theme created' or 'Create failed', ch and cg or tostring(ci))
        end
        function bT:Save(cg)
            cg = cg or cd()
            if not cg then
                return
            end
            local ch, ci = bS:SaveTheme(cg)
            cb(ch, ch and 'Theme saved' or 'Save failed', ch and cg or tostring(ci))
        end
        function bT:Load(cg)
            cg = cg or cd()
            if not cg then
                return
            end
            local ch, ci = bS:LoadTheme(cg)
            if ch then
                bX:Set(nil, true)
            end
            cb(ch ~= false, ch and 'Theme loaded' or 'Load failed', ch and cg or tostring(ci))
        end
        function bT:Delete(cg)
            cg = cg or cd()
            if not cg then
                return
            end
            bS:Confirm(
                {
                    Title = 'Delete theme', Content = 'Remove ' .. cg .. '? This cannot be undone.',
                    Icon = 'trash-2', ConfirmText = 'Delete',
                    Callback = function()
                        local ch, ci = bS:DeleteTheme(cg)
                        bT:Refresh()
                        cb(ch, ch and 'Theme deleted' or 'Delete failed', ch and cg or tostring(ci))
                    end
                }
            )
        end
        function bT:ToggleDefault(cg)
            cg = cg or bU:Get() or bX:Get()
            if not cg then
                cb(false, 'Nothing selected', 'Pick a theme or a preset first')
                return
            end
            local ch = bS:GetDefaultTheme() == cg
            local ci, cj = bS:SetDefaultTheme(not ch and cg or nil)
            cc()
            cb(
                ci ~= false, ch and 'Default cleared' or 'Default theme set',
                ci ~= false and cg or tostring(cj)
            )
        end
        if bQ.Customize ~= false then
            bR:Divider()
            local cg = bQ.Colors or {
                {'Accent', 'Accent'}, {'Background', 'Background'}, {'Surface2', 'Surface'},
                {'Text', 'Text'}, {'Muted', 'Muted text'}
            }
            for ch, ci in ipairs(cg) do
                local cj, ck = ci[1], ci[2] or ci[1]
                local cl, cm = nil, false
                local cn
                cn = bR:ColorPicker(
                    {
                        Name = ck, Default = z[cj],
                        Callback = function(co)
                            cl = co
                            if cm then
                                return
                            end
                            cm = true
                            task.delay(
                                0.08,
                                function()
                                    cm = false
                                    k:SetTheme({[cj] = cl}, true)
                                    bX:Set(nil, true)
                                end
                            )
                        end
                    }
                )
                table.insert(
                    k._themeListeners,
                    function()
                        if cn.Value ~= z[cj] then
                            cn:Set(z[cj], true)
                        end
                    end
                )
            end
        end
        if bQ.Flag ~= false then
            local cg = type(bQ.Flag) == 'string' and bQ.Flag or '__Theme'
            local ch = {
                _type = 'Theme', _searchName = 'Theme', _searchKey = 'theme', _listeners = {}
            }
            function ch:Get()
                local ci = {}
                for cj, ck in ipairs(n) do
                    ci[ck] = bc(z[ck])
                end
                return {
                    Name = bX:Get() or bU:Get(), Colors = ci, Weather = bY and bS.Weather or nil,
                    WeatherMode = bZ and bS.WeatherMode or nil,
                    Dim = if b_ then bS._backdropDim == true else nil,
                    Transparent = if b0 then bS.Transparent == true else nil,
                    DragStyle = b1 and bS.DragStyle or nil,
                    IslandStyle = b2 and bS.IslandStyle or nil,
                    CornerRadius = ca and k:GetCornerRadius() or nil,
                    UIScale = b7 and bS:GetUIScale() or nil,
                    AdaptiveSize = if b9 then bS:GetAdaptiveSize() else nil,
                    Density = b8 and k.Density or nil,
                    Background = b3 and (bS.Background or '') or nil,
                    BackgroundTransparency = b3 and bS.BackgroundTransparency or nil
                }
            end
            function ch:Set(ci)
                if type(ci) ~= 'table' then
                    return
                end
                if type(ci.Colors) == 'table' then
                    k:SetTheme(ci.Colors)
                end
                local cj = type(ci.Name) == 'string' and ci.Name or nil
                if cj and k.ThemePresets[cj] then
                    k.ThemeName = cj
                    bX:Set(cj, true)
                    bU:Set(nil, true)
                else
                    if cj then
                        k.ThemeName = cj
                    end
                    bX:Set(nil, true)
                    bU:Set(cj and table.find(bS:ListThemes(), cj) and cj or nil, true)
                end
                if bY and type(ci.Weather) == 'string' then
                    bS:SetWeather(ci.Weather)
                    bY:Set(ce[bS.Weather] or 'None', true)
                end
                if bZ and type(ci.WeatherMode) == 'string' then
                    bS:SetWeatherMode(ci.WeatherMode)
                    bZ:Set(bS.WeatherMode, true)
                end
                if b_ and type(ci.Dim) == 'boolean' then
                    bS:SetDim(ci.Dim)
                    b_:Set(ci.Dim, true)
                end
                if b0 and type(ci.Transparent) == 'boolean' then
                    bS:SetTransparent(ci.Transparent)
                    b0:Set(ci.Transparent, true)
                end
                if b1 and type(ci.DragStyle) == 'string' then
                    b1:Set(bS:SetDragStyle(ci.DragStyle), true)
                elseif b1 and type(ci.DragSkeleton) == 'boolean' then
                    bS:SetDragSkeleton(ci.DragSkeleton)
                    b1:Set(bS.DragStyle, true)
                end
                if b2 and type(ci.IslandStyle) == 'string' then
                    b2:Set(bS:SetIslandStyle(ci.IslandStyle), true)
                end
                if ca and tonumber(ci.CornerRadius) then
                    ca:Set(k:SetCornerRadius(ci.CornerRadius), true)
                end
                if b9 and type(ci.AdaptiveSize) == 'boolean' then
                    bS:SetAdaptiveSize(ci.AdaptiveSize)
                    b9:Set(ci.AdaptiveSize, true)
                end
                if b7 and tonumber(ci.UIScale) then
                    bS:SetUIScale(tonumber(ci.UIScale))
                    b7:Set(math.floor(bS:GetUIScale() * 100 + 0.5), true)
                end
                if b8 and type(ci.Density) == 'string' then
                    b8:Set(k:SetDensity(ci.Density), true)
                end
                if b3 and tonumber(ci.BackgroundTransparency) then
                    bS:SetBackgroundTransparency(tonumber(ci.BackgroundTransparency))
                    b5:Set(math.floor((1 - bS.BackgroundTransparency) * 100 + 0.5), true)
                end
                if b3 and type(ci.Background) == 'string' and ci.Background ~= (bS.Background or '') then
                    local ck = ci.Background
                    b3:Set(b6(ck), true)
                    task.spawn(bS.SetBackground, bS, ck)
                end
                cc()
            end
            k.Flags[cg] = ch
            bS:_flagCreated(cg, ch)
        end
        bS._workspaceListeners = bS._workspaceListeners or {}
        table.insert(
            bS._workspaceListeners,
            function()
                bU:Set(nil, true)
                bT:Refresh()
            end
        )
        cc()
        return bT
    end
    aS.CreateButtonRow = aS.ButtonRow
    aS.CreateConfigManager = aS.ConfigManager
    aS.CreateThemeManager = aS.ThemeManager
    local bQ = {Plain = 22, Row = 24, Badge = 28, Dot = 24, Bar = 38, Stat = 46}
    local function bR(bS)
        return k._color(bS) or z.Accent
    end
    local function bS(bT)
        if bT == math.floor(bT) then
            return tostring(math.floor(bT))
        end
        return string.format('%.1f', bT)
    end
    local function bT(bU, bV)
        if type(bU) == 'number' and type(bV) == 'number' then
            return bU, bV
        end
        if type(bU) == 'string' then
            local bW = (bU:gsub(',', ''))
            local bX, bY = bW:match('^%s*(%-?[%d%.]+)%s*/%s*(%-?[%d%.]+)')
            if bX then
                return tonumber(bX), tonumber(bY)
            end
        end
        return nil, nil
    end
    function aS:Status(bU)
        bU = l(
            bU,
            {Title = 'Name', Text = 'Value', Content = 'Value', CurrentValue = 'Value', Default = 'Value'}
        )
        local bV = bQ[bU.Style] and bU.Style or 'Plain'
        local bW = aM(self).Compact
        local bX = self.Window
        local bY = bQ[bV]
        local bZ = bW and 0 or 8
        local b_ = aO(self, 'Frame', bY + bZ * 2, bU)
        local b0 = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(14, bZ), Size = UDim2.new(1, -28, 0, bY),
                BackgroundTransparency = 1, Parent = b_
            }
        )
        local b1 = {
            Value = bU.Value, Max = bU.Max, Tone = bU.Tone or 'Accent', Name = bU.Name or '',
            Color = bU.Color or bU.ValueColor
        }
        local b2, b3, b4, b5, b6, b7, b8
        local b9 = false
        local function ca()
            return bV == 'Plain' and (b1.Name .. ':') or b1.Name
        end
        if bV == 'Plain' then
            ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = b0
                }
            )
            b2 = am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = 1, Parent = b0
                }
            )
            b3 = am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12, TextColor3 = z.Text, TextTruncate = Enum.TextTruncate.None,
                    LayoutOrder = 2, Parent = b0
                }
            )
        elseif bV == 'Stat' then
            b2 = am(
                {
                    Position = UDim2.fromOffset(0, 3), Size = UDim2.new(1, 0, 0, 14), TextSize = 11,
                    TextColor3 = z.Muted, Parent = b0
                }
            )
            b3 = am(
                {
                    Position = UDim2.fromOffset(0, 18), Size = UDim2.new(1, 0, 0, 24),
                    TextSize = 20, FontFace = D.Bold, TextColor3 = z.Text, Parent = b0
                }
            )
        else
            local cb = 0
            if bV == 'Dot' then
                cb = 18
                b7 = ai(
                    'Frame',
                    {
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 5, 0.5, 0),
                        Size = UDim2.fromOffset(8, 8), BackgroundColor3 = bR(b1.Tone),
                        BackgroundTransparency = 0.4, BorderSizePixel = 0, Parent = b0
                    }
                )
                aj(b7, UDim.new(1, 0))
                b6 = ai(
                    'Frame',
                    {
                        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 5, 0.5, 0),
                        Size = UDim2.fromOffset(8, 8), BackgroundColor3 = bR(b1.Tone),
                        BorderSizePixel = 0, Parent = b0
                    }
                )
                aj(b6, UDim.new(1, 0))
                if bU.Pulse ~= false then
                    a:Create(
                        b7, TweenInfo.new(1.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1),
                        {Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1}
                    ):Play()
                else
                    b7.Visible = false
                end
            end
            local cc = bV == 'Bar' and 18 or bY
            b2 = am(
                {
                    Position = UDim2.fromOffset(cb, 0), Size = UDim2.new(0.55, -cb, 0, cc),
                    TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted, Parent = b0
                }
            )
            if bV == 'Badge' then
                b9 = true
                b4 = ai(
                    'Frame',
                    {
                        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                        Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundColor3 = bR(b1.Tone), BackgroundTransparency = 0.86,
                        BorderSizePixel = 0, Parent = b0
                    }
                )
                aj(b4, UDim.new(1, 0))
                b5 = ak(b4, bR(b1.Tone), 0.6)
                al(b4, 10, 10)
                b3 = am(
                    {
                        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 12, TextColor3 = bR(b1.Tone),
                        TextTruncate = Enum.TextTruncate.None, Parent = b4
                    }
                )
            else
                b3 = am(
                    {
                        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                        Size = UDim2.new(0.45, 0, 0, cc), TextSize = 12, TextColor3 = z.Text,
                        TextXAlignment = Enum.TextXAlignment.Right, Parent = b0
                    }
                )
            end
            if bV == 'Bar' then
                local cd = ai(
                    'Frame',
                    {
                        Position = UDim2.fromOffset(0, 25), Size = UDim2.new(1, 0, 0, 5),
                        BackgroundColor3 = z.Surface3, BorderSizePixel = 0, ClipsDescendants = true,
                        Parent = b0
                    }
                )
                aj(cd, UDim.new(1, 0))
                b8 = ai(
                    'Frame',
                    {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = bR(b1.Tone), BorderSizePixel = 0, Parent = cd}
                )
                aj(b8, UDim.new(1, 0))
            end
        end
        local cb = nil
        local function cc(cd)
            b2.Text = k._rich(ca())
            local ce = b1.Value
            local cf = ce == nil and (bU.Placeholder or '-') or tostring(ce)
            if bV == 'Bar' then
                local cg, ch = bT(ce, b1.Max)
                if cg and ch then
                    b1.Max = ch
                    cf = bS(cg) .. ' / ' .. bS(ch)
                    local ci = ch > 0 and math.clamp(cg / ch, 0, 1) or 0
                    ah(b8, {Size = UDim2.new(ci, 0, 1, 0)}, cd and 0.4 or 0, Enum.EasingStyle.Quint)
                elseif type(ce) == 'number' and ce <= 1 then
                    cf = string.format('%d%%', math.floor(ce * 100 + 0.5))
                    ah(
                        b8, {Size = UDim2.new(math.clamp(ce, 0, 1), 0, 1, 0)}, cd and 0.4 or 0,
                        Enum.EasingStyle.Quint
                    )
                end
            end
            cf = k._rich((bU.Prefix or '') .. cf .. (bU.Suffix or ''))
            local cg = cb ~= nil and cf ~= cb
            cb = cf
            b3.Text = cf
            local ch = bR(b1.Tone)
            local ci = cd and 0.25 or 0
            local cj = not b9 and k._color(b1.Color) or z.Text
            if not b9 and not (cg and cd and bU.Flash ~= false) then
                ah(b3, {TextColor3 = cj}, ci)
            end
            if b4 then
                ah(b4, {BackgroundColor3 = ch}, ci)
                ah(b5, {Color = ch}, ci)
                ah(b3, {TextColor3 = ch}, ci)
            end
            if b6 then
                ah(b6, {BackgroundColor3 = ch}, ci)
                ah(b7, {BackgroundColor3 = ch}, 0)
            end
            if b8 then
                ah(b8, {BackgroundColor3 = ch}, ci)
            end
            if cg and cd and not b9 and bU.Flash ~= false then
                ah(b3, {TextColor3 = z.Accent}, 0.08)
                task.delay(
                    0.1,
                    function()
                        if b3.Parent then
                            ah(b3, {TextColor3 = k._color(b1.Color) or z.Text}, 0.45)
                        end
                    end
                )
            end
        end
        b2.RichText = true
        b3.RichText = true
        ag(
            b0,
            function()
                if cb ~= nil then
                    cc(false)
                end
            end
        )
        function b1:Set(cd, ce)
            b1.Value = cd
            if ce ~= nil then
                b1.Max = ce
            end
            cc(true)
        end
        function b1:Get()
            return b1.Value
        end
        function b1:SetTone(cd)
            b1.Tone = cd
            cc(true)
        end
        function b1:SetColor(cd)
            b1.Color = cd
            cc(true)
        end
        function b1:SetName(cd)
            b1.Name = tostring(cd)
            cc(false)
        end
        function b1:Text()
            return b3.Text
        end
        function b1._shownColor()
            if b1.Color ~= nil then
                return k._color(b1.Color) or z.Text
            end
            if bV == 'Badge' or bV == 'Dot' or bV == 'Bar' then
                return bR(b1.Tone)
            end
            return z.Text
        end
        b1._listeners = {}
        if type(bU.Update) == 'function' then
            local cd = math.max(tonumber(bU.UpdateRate) or 1, 0.05)
            local ce = true
            table.insert(
                b1._listeners,
                function()
                    ce = false
                end
            )
            task.spawn(
                function()
                    while ce and b_.Parent do
                        local cf, cg, ch = aK(bU.Update)
                        if cf then
                            if cg ~= nil then
                                b1.Value = cg
                            end
                            if type(ch) == 'number' then
                                b1.Max = ch
                            elseif type(ch) == 'string' or typeof(ch) == 'Color3' then
                                b1.Tone = ch
                            end
                            cc(true)
                        else
                            warn('[AirFlow] status update error: ' .. tostring(cg))
                        end
                        task.wait(cd)
                    end
                end
            )
            function b1:SetUpdateRate(cf)
                cd = math.max(tonumber(cf) or cd, 0.05)
            end
        end
        if bU.Pin then
            table.insert(bX._pinned, b1)
            table.insert(
                b1._listeners,
                function()
                    local cd = table.find(bX._pinned, b1)
                    if cd then
                        table.remove(bX._pinned, cd)
                    end
                end
            )
        end
        cc(false)
        return m(self, bU, b1, b_, 'Status')
    end
    function aS:Statuses(bU, bV)
        local bW = {}
        for bX, bY in ipairs(bU or {}) do
            local bZ = type(bY) == 'table' and table.clone(bY) or {Name = tostring(bY)}
            for b_, b0 in pairs(bV or {}) do
                if bZ[b_] == nil then
                    bZ[b_] = b0
                end
            end
            local b_ = self:Status(bZ)
            bW[bZ.Name or bZ.Title or bX] = b_
        end
        return bW
    end
    function aS:StatusList(bU)
        bU = l(bU, {Title = 'Name'})
        local bV = aM(self).Compact
        local bW = self.Window
        local bX = math.max(math.floor(tonumber(bU.MaxRows) or 5), 1)
        local bY = aO(self, 'Frame', 0, bU)
        bY.AutomaticSize = Enum.AutomaticSize.Y
        if bV then
            al(bY, 14, 14, 6, 8)
        else
            al(bY, 14, 14, 11, 12)
        end
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = bY}
        )
        local bZ = am(
            {
                Size = UDim2.new(1, 0, 0, 16), Text = string.upper(tostring(bU.Name or '')),
                TextSize = 11, TextColor3 = z.Muted, Visible = tostring(bU.Name or '') ~= '',
                LayoutOrder = 1, Parent = bY
            }
        )
        local b_ = ai(
            'ScrollingFrame',
            {
                Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 2, ScrollBarImageColor3 = z.Accent,
                ScrollBarImageTransparency = 0.4, ScrollingDirection = Enum.ScrollingDirection.Y,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
                ScrollingEnabled = false, LayoutOrder = 2, Parent = bY
            }
        )
        b_:SetAttribute('NoDrag', true)
        local b0 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = b_
            }
        )
        local b1 = al(b0, 0, 0, 0, 0)
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b0}
        )
        local b2 = am(
            {
                Size = UDim2.new(1, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.Y,
                Text = tostring(bU.EmptyText or 'Nothing yet'), TextSize = 13, LineHeight = 1.1,
                FontFace = D.Regular, TextColor3 = z.Muted, TextWrapped = true,
                TextTruncate = Enum.TextTruncate.None, LayoutOrder = 0, Parent = b0
            }
        )
        local b3, b4, b5, b6 = {}, {}, nil, {}
        local b7 = {_listeners = {}}
        local function b8()
            if b7._destroyed then
                return
            end
            local b9 = bW.Scale.Scale
            local ca = #b4
            local cb = 0
            if ca == 0 then
                cb = b2.AbsoluteSize.Y / b9
            else
                local cc = math.min(ca, bX)
                for cd = 1, cc do
                    cb += b3[cd].Frame.AbsoluteSize.Y / b9
                end
                cb += (cc - 1) * 2
            end
            cb = math.ceil(cb)
            local cc = ca > bX
            b_.ScrollingEnabled = cc
            b1.PaddingRight = UDim.new(0, cc and 8 or 0)
            if b_.Size.Y.Offset ~= cb then
                b_.Size = UDim2.new(1, 0, 0, cb)
            end
            local cd = math.max(b_.AbsoluteCanvasSize.Y - b_.AbsoluteWindowSize.Y, 0) / b9
            if b_.CanvasPosition.Y > cd then
                b_.CanvasPosition = Vector2.new(0, cd)
            end
        end
        local function b9(ca)
            if ca.Value.Visible then
                ca.Text.Size = UDim2.new(
                    1, -(math.ceil(ca.Value.AbsoluteSize.X / bW.Scale.Scale) + 12), 0, 24
                )
            else
                ca.Text.Size = UDim2.new(1, 0, 0, 24)
            end
        end
        local function ca(cb)
            local cc = ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, LayoutOrder = cb, Parent = b0
                }
            )
            local cd = {
                Frame = cc,
                Text = am(
                    {
                        Size = UDim2.new(1, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.Y,
                        Text = '', TextSize = 13, LineHeight = 1.1, FontFace = D.Regular,
                        TextColor3 = z.Muted, TextWrapped = true,
                        TextTruncate = Enum.TextTruncate.None, RichText = true, Parent = cc
                    }
                ),
                Value = am(
                    {
                        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
                        Size = UDim2.new(0, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.X,
                        Text = '', TextSize = 12, FontFace = D.Medium, TextColor3 = z.Text,
                        RichText = true, TextXAlignment = Enum.TextXAlignment.Right,
                        TextTruncate = Enum.TextTruncate.None, Visible = false, Parent = cc
                    }
                )
            }
            cd.Connections = {
                cc:GetPropertyChangedSignal('AbsoluteSize'):Connect(b8),
                cd.Value:GetPropertyChangedSignal('AbsoluteSize'):Connect(
                    function()
                        b9(cd)
                    end
                )
            }
            return cd
        end
        local function cb(cc)
            if type(cc) == 'table' then
                local cd = cc.Text or cc.Name or cc[1]
                local ce = cc.Tone or cc.Color
                return {
                    Text = tostring(cd == nil and '' or cd),
                    Value = cc.Value ~= nil and tostring(cc.Value) or nil,
                    Tone = (type(ce) == 'string' or typeof(ce) == 'Color3') and ce or nil
                }
            end
            return {Text = tostring(cc)}
        end
        local function cc(cd)
            return cd.Text .. '\0' .. (cd.Value or '\1') .. '\0' .. tostring(cd.Tone or '')
        end
        local function cd(ce, cf)
            local cg = cc(cf)
            if ce.Key == cg then
                return
            end
            ce.Key = cg
            ce.Text.Text = k._rich(cf.Text)
            local ch = cf.Tone and k._color(cf.Tone) or nil
            if cf.Value then
                ce.Value.Text = k._rich(cf.Value)
                ce.Value.Visible = true
                ah(ce.Value, {TextColor3 = ch or z.Text}, 0)
                ah(ce.Text, {TextColor3 = z.Muted}, 0)
            else
                ce.Value.Visible = false
                ah(ce.Text, {TextColor3 = ch or z.Muted}, 0)
            end
            b9(ce)
        end
        local function ce(cf)
            for cg, ch in ipairs(cf.Connections) do
                ch:Disconnect()
            end
            cf.Frame:Destroy()
        end
        function b7:Set(cf)
            if type(cf) ~= 'table' or b7._destroyed then
                return
            end
            local cg, ch = {}, {}
            b6 = {}
            for ci, cj in ipairs(cf) do
                b6[ci] = type(cj) == 'table' and table.clone(cj) or cj
                local ck = cb(cj)
                cg[ci] = ck
                ch[ci] = cc(ck)
            end
            local ci = table.concat(ch, '\2') .. '#' .. #cg
            if ci == b5 then
                return
            end
            b5 = ci
            b4 = cg
            for cj, ck in ipairs(b4) do
                local cl = b3[cj]
                if not cl then
                    cl = ca(cj)
                    b3[cj] = cl
                end
                cd(cl, ck)
            end
            for cj = #b3, #b4 + 1, -1 do
                ce(b3[cj])
                b3[cj] = nil
            end
            b2.Visible = #b4 == 0
            b8()
        end
        function b7:Get()
            local cf = {}
            for cg, ch in ipairs(b6) do
                cf[cg] = type(ch) == 'table' and table.clone(ch) or ch
            end
            return cf
        end
        function b7:Clear()
            b7:Set({})
        end
        function b7:SetName(cf)
            cf = tostring(cf or '')
            bZ.Text = string.upper(cf)
            bZ.Visible = cf ~= ''
            b7._searchName = cf
            b7._searchKey = string.lower(cf)
        end
        local cf = math.max(tonumber(bU.UpdateRate) or 1, 0.05)
        function b7:SetUpdateRate(cg)
            cf = math.max(tonumber(cg) or cf, 0.05)
        end
        ag(
            b0,
            function()
                for cg, ch in ipairs(b3) do
                    if b4[cg] then
                        ch.Key = nil
                        cd(ch, b4[cg])
                    end
                end
            end
        )
        local cg = b2:GetPropertyChangedSignal('AbsoluteSize'):Connect(b8)
        table.insert(
            b7._listeners,
            function()
                b7._destroyed = true
                cg:Disconnect()
                for ch, ci in ipairs(b3) do
                    for cj, ck in ipairs(ci.Connections) do
                        ck:Disconnect()
                    end
                end
            end
        )
        local function ch()
            if bW._destroyed or not bW.Open or bW.Minimized or not b7._userVisible then
                return false
            end
            local ci = self
            if ci._groupbox then
                if ci._userVisible == false then
                    return false
                end
                ci = ci.Parent
            end
            if ci._isSubTab then
                if ci.Parent.CurrentSubTab ~= ci then
                    return false
                end
                ci = ci.Parent
            end
            return bW.CurrentTab == ci
        end
        if type(bU.Update) == 'function' then
            local ci = true
            table.insert(
                b7._listeners,
                function()
                    ci = false
                end
            )
            task.defer(
                function()
                    local cj = true
                    while ci and bY.Parent do
                        if cj or ch() then
                            cj = false
                            local ck, cl = aK(bU.Update)
                            if ck then
                                if cl ~= nil then
                                    b7:Set(cl)
                                end
                            else
                                warn('[AirFlow] status list update error: ' .. tostring(cl))
                            end
                        end
                        task.wait(cf)
                    end
                end
            )
        end
        b7:Set(bU.Rows or {})
        return m(self, bU, b7, bY, 'StatusList')
    end
    aS.CreateStatus = aS.Status
    aS.AddStatus = aS.Status
    aS.CreateStatuses = aS.Statuses
    aS.CreateStatusList = aS.StatusList
    aS.AddStatusList = aS.StatusList
    function aS:_mediaCard(bU, bV)
        bU = l(bU, {Title = 'Name', Description = 'Desc'})
        local bW = aM(self)
        local bX = bW.Compact
        local bY = math.clamp(tonumber(bU.Height) or bV, 40, 600)
        local bZ = bX and 14 or 8
        local b_ = type(bU.Name) == 'string' and bU.Name ~= ''
        local b0 = bX and 4 or 10
        local b1 = b_ and (b0 + (bU.Desc and 38 or 22)) or (bX and 4 or bZ)
        local b2 = b1 + bY + (bX and 6 or bZ)
        local b3, b4 = aO(self, 'Frame', b2, bU)
        aG(b3, b4)
        local b5, b6
        if b_ then
            b5 = am(
                {
                    Position = UDim2.fromOffset(14, b0),
                    Size = UDim2.new(1, -28, 0, bW.TitleHeight), Text = bU.Name,
                    TextSize = bW.TextSize, Parent = b3
                }
            )
            if bU.Desc then
                b6 = am(
                    {
                        Position = UDim2.fromOffset(14, b0 + bW.TitleHeight + 1),
                        Size = UDim2.new(1, -28, 0, bW.DescLine), Text = bU.Desc,
                        TextSize = bW.DescSize, FontFace = D.Regular, TextColor3 = z.Muted,
                        Parent = b3
                    }
                )
            end
        end
        local b7 = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(bZ, b1), Size = UDim2.new(1, -bZ * 2, 0, bY),
                BackgroundColor3 = z.Surface3, BackgroundTransparency = 0.5, BorderSizePixel = 0,
                ClipsDescendants = true, Parent = b3
            }
        )
        aj(b7, UDim.new(0, 6))
        ak(b7, z.Stroke)
        local b8 = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(22, 22), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ImageTransparency = 0.3, ScaleType = Enum.ScaleType.Fit, Parent = b7
            }
        )
        local b9 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.35, BorderSizePixel = 0, Visible = false, ZIndex = 3,
                Parent = b7
            }
        )
        ai('UIGradient', {Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = b9})
        local ca = am(
            {
                Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -20, 1, -10), TextSize = 12,
                TextColor3 = Color3.new(1, 1, 1), ZIndex = 4, Parent = b9
            }
        )
        local function cb(cc)
            cc = cc ~= nil and tostring(cc) or ''
            ca.Text = cc
            b9.Visible = cc ~= ''
        end
        cb(bU.Caption)
        return
            bU,
            {Frame = b3, Stroke = b4, Media = b7, Placeholder = b8, Title = b5, Desc = b6, SetCaption = cb}
    end
    function aS:Image(bU)
        local bV
        bU, bV = self:_mediaCard(bU, 160)
        local bW = self.Window
        local bX = bV.Media
        aq(bV.Placeholder, 'image')
        local function bY(bZ, b_)
            local b0, b1 = pcall(
                function()
                    return Enum.ScaleType[tostring(bZ)]
                end
            )
            return b0 and b1 or b_
        end
        local bZ = ai(
            'ImageLabel',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ImageTransparency = 1,
                ScaleType = bY(bU.ScaleType or 'Crop', Enum.ScaleType.Crop), ZIndex = 2, Parent = bX
            }
        )
        aj(bZ, UDim.new(0, 6))
        if bU.Color then
            bZ.ImageColor3 = bU.Color
        end
        local b_ = {Value = nil}
        local b0 = 0
        function b_:SetImage(b1)
            b0 += 1
            local b2 = b0
            b_.Value = b1
            if b1 == nil or b1 == '' or b1 == 'None' then
                ah(bZ, {ImageTransparency = 1}, 0.2)
                ah(bV.Placeholder, {ImageTransparency = 0.3}, 0.2)
                return true
            end
            local b3, b4
            if type(b1) == 'number' then
                b3 = 'rbxassetid://' .. math.floor(b1)
            elseif type(b1) == 'string' and ({avatar = true, headshot = true})[b1:lower()] then
                b3 = 'rbxthumb://type=AvatarHeadShot&id=' .. j.UserId .. '&w=420&h=420'
            else
                local b5, b6, b7 = pcall(bW._resolveBackground, bW, tostring(b1))
                if b5 then
                    b3, b4 = b6, b7
                else
                    b4 = tostring(b6)
                end
            end
            if b0 ~= b2 then
                return false, 'replaced by a newer image'
            end
            if not b3 then
                warn('[AirFlow] image: ' .. tostring(b4))
                return false, b4
            end
            bZ.ImageTransparency = 1
            bZ.Image = b3
            task.spawn(
                function()
                    local b5 = 0
                    while not bZ.IsLoaded and b5 < 4 and b0 == b2 and bZ.Parent do
                        b5 += task.wait(0.05)
                    end
                    if b0 == b2 and bZ.Parent then
                        ah(bZ, {ImageTransparency = 0}, 0.35)
                        ah(bV.Placeholder, {ImageTransparency = 1}, 0.2)
                    end
                end
            )
            return true
        end
        b_.Set = b_.SetImage
        function b_:Get()
            return b_.Value
        end
        function b_:SetCaption(b1)
            bV.SetCaption(b1)
        end
        function b_:SetScaleType(b1)
            bZ.ScaleType = bY(b1, bZ.ScaleType)
        end
        function b_:SetColor(b1)
            bZ.ImageColor3 = typeof(b1) == 'Color3' and b1 or Color3.new(1, 1, 1)
        end
        function b_:SetTitle(b1)
            if bV.Title then
                bV.Title.Text = tostring(b1)
            end
        end
        if bU.Image ~= nil then
            task.spawn(b_.SetImage, b_, bU.Image)
        end
        return m(self, bU, b_, bV.Frame, 'Image')
    end
    function aS:Viewport(bU)
        local bV
        bU, bV = self:_mediaCard(bU, 180)
        local bW = self.Window
        local bX = bV.Media
        aq(bV.Placeholder, 'box')
        local bY = ai(
            'ViewportFrame',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ImageTransparency = 1,
                Ambient = bU.Ambient or Color3.fromRGB(165, 160, 175),
                LightColor = bU.LightColor or Color3.fromRGB(255, 250, 245),
                LightDirection = Vector3.new(-0.6, -1, -0.8), ZIndex = 2, Parent = bX
            }
        )
        local bZ = Instance.new('Camera')
        bZ.FieldOfView = math.clamp(tonumber(bU.FieldOfView) or 35, 10, 90)
        bZ.Parent = bY
        bY.CurrentCamera = bZ
        local b_ = Instance.new('WorldModel')
        b_.Parent = bY
        local b0 = {Model = nil, Spin = bU.Spin ~= false, SpinSpeed = tonumber(bU.SpinSpeed) or 25}
        local b1 = math.rad(tonumber(bU.Angle) or 0)
        local b2 = math.rad(tonumber(bU.Pitch) or 10)
        local b3 = tonumber(bU.Distance) or 1
        local b4, b5, b6 = nil, 10, CFrame.new()
        local b7 = nil
        local b8 = 0
        local b9, ca, cb = false, 0, 0
        local function cc()
            if not b4 then
                return
            end
            local cd = b6:VectorToWorldSpace(
                Vector3.new(math.sin(b1) * math.cos(b2), math.sin(b2), -math.cos(b1) * math.cos(b2))
            )
            bZ.CFrame = CFrame.lookAt(b4 + cd * b5, b4)
        end
        local function cd(ce)
            local cf, cg
            if ce:IsA('Model') then
                cf, cg = ce:GetBoundingBox()
                b6 = ce:GetPivot().Rotation
            elseif ce:IsA('BasePart') then
                cf, cg = ce.CFrame, ce.Size
                b6 = ce.CFrame.Rotation
            else
                return false
            end
            b4 = cf.Position
            local ch = math.max(cg.Magnitude / 2, 0.5)
            b5 = ch / math.tan(math.rad(bZ.FieldOfView / 2)) * b3
            cc()
            return true
        end
        local function ce(cf)
            local cg = cf
            if bU.Clone ~= false then
                local ch = cf.Archivable
                pcall(
                    function()
                        cf.Archivable = true
                    end
                )
                local ci, cj = pcall(cf.Clone, cf)
                pcall(
                    function()
                        cf.Archivable = ch
                    end
                )
                cg = ci and cj or nil
            end
            if not cg then
                return nil
            end
            local function ch(ci)
                if ci:IsA('LuaSourceContainer') or ci:IsA('Sound') or ci:IsA('ForceField') then
                    ci:Destroy()
                elseif ci:IsA('BasePart') then
                    ci.Anchored = true
                    ci.CanCollide = false
                end
            end
            for ci, cj in ipairs(cg:GetDescendants()) do
                pcall(ch, cj)
            end
            if cg:IsA('BasePart') then
                cg.Anchored = true
            end
            local ci = cg:FindFirstChildOfClass('Humanoid')
            if ci then
                ci.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
            return cg
        end
        local function cf(cg)
            if type(cg) == 'function' then
                local ch, ci = pcall(cg)
                cg = ch and ci or nil
            end
            if type(cg) == 'string' and ({avatar = true, player = true, character = true})[cg:lower(
            )] then
                cg = j
            end
            if typeof(cg) == 'Instance' and cg:IsA('Player') then
                local ch = cg.Character
                if not ch then
                    ch = cg.CharacterAdded:Wait()
                    task.wait(0.5)
                end
                cg = ch
            end
            return typeof(cg) == 'Instance' and cg or nil
        end
        function b0:SetModel(cg)
            b8 += 1
            local ch = b8
            b7 = cg
            if b0.Model then
                b0.Model:Destroy()
                b0.Model = nil
            end
            b4 = nil
            if cg == nil then
                ah(bY, {ImageTransparency = 1}, 0.2)
                ah(bV.Placeholder, {ImageTransparency = 0.3}, 0.2)
                return true
            end
            local ci = cf(cg)
            if b8 ~= ch then
                return false, 'replaced by a newer model'
            end
            if not ci then
                return false, 'no model to show'
            end
            local cj = ce(ci)
            if not cj then
                return false, 'could not copy the model'
            end
            cj.Parent = b_
            b0.Model = cj
            if not cd(cj) then
                cj:Destroy()
                b0.Model = nil
                return false, 'not a Model or a part'
            end
            bY.ImageTransparency = 1
            ah(bY, {ImageTransparency = 0}, 0.35)
            ah(bV.Placeholder, {ImageTransparency = 1}, 0.2)
            return true
        end
        b0.Set = b0.SetModel
        function b0:Get()
            return b0.Model
        end
        function b0:Refresh()
            return b0:SetModel(b7)
        end
        function b0:SetSpin(cg)
            b0.Spin = cg ~= false
        end
        function b0:SetSpinSpeed(cg)
            b0.SpinSpeed = tonumber(cg) or b0.SpinSpeed
        end
        function b0:SetAngle(cg)
            b1 = math.rad(tonumber(cg) or 0)
            cc()
        end
        function b0:SetCaption(cg)
            bV.SetCaption(cg)
        end
        function b0:SetTitle(cg)
            if bV.Title then
                bV.Title.Text = tostring(cg)
            end
        end
        bX.InputBegan:Connect(
            function(cg)
                if aw(cg) and b0.Model then
                    b9 = true
                    ca = av().X
                end
            end
        )
        bW:_listen(
            'Changed',
            function(cg)
                if b9 and aA(cg) then
                    local ch = av().X
                    b1 -= (ch - ca) * 0.012
                    ca = ch
                    cc()
                end
            end, b0
        )
        bW:_listen(
            'Ended',
            function(cg)
                if b9 and aw(cg) then
                    b9 = false
                    cb = os.clock() + 1.5
                end
            end, b0
        )
        bW:_listen(
            'Render',
            function(cg)
                if b0.Spin and b4 and not b9 and os.clock() >= cb and bW.Open and not bW.Minimized and bV.Frame.Visible then
                    b1 += math.rad(b0.SpinSpeed) * cg
                    cc()
                end
            end, b0
        )
        if bU.Model ~= nil then
            task.spawn(b0.SetModel, b0, bU.Model)
        end
        return m(self, bU, b0, bV.Frame, 'Viewport')
    end
    function aS:Table(bU)
        bU = l(bU, {Title = 'Name', Description = 'Desc', Data = 'Rows', OnRowClick = 'Callback'})
        local bV = self.Window
        local bW = aM(self)
        local bX = bW.Compact
        local bY = tonumber(bU.RowHeight) or (E and 32 or 26)
        local bZ = math.max(math.floor(tonumber(bU.MaxRows) or 8), 1)
        local b_ = E and 28 or 24
        local b0 = bX and 12 or 13
        local b1 = bX and 14 or 8
        local b2 = type(bU.Name) == 'string' and bU.Name ~= ''
        local b3 = bX and 4 or 10
        local b4 = bU.Search ~= false
        local b5 = E and 30 or 26
        local b6 = b2 and (b3 + (bU.Desc and 38 or 22)) or (bX and 4 or b1)
        local b7 = b6 + (b4 and b5 + 6 or 0)
        local b8 = bX and 6 or b1
        local b9, ca = aO(self, 'Frame', b7 + b_ + bY + b8, bU)
        aG(b9, ca)
        local cb
        if b2 then
            cb = am(
                {
                    Position = UDim2.fromOffset(14, b3),
                    Size = UDim2.new(1, -28, 0, bW.TitleHeight), Text = bU.Name,
                    TextSize = bW.TextSize, Parent = b9
                }
            )
            if bU.Desc then
                am(
                    {
                        Position = UDim2.fromOffset(14, b3 + bW.TitleHeight + 1),
                        Size = UDim2.new(1, -28, 0, bW.DescLine), Text = bU.Desc,
                        TextSize = bW.DescSize, FontFace = D.Regular, TextColor3 = z.Muted,
                        Parent = b9
                    }
                )
            end
        end
        local cc = ''
        local cd, ce
        if b4 then
            local cf = ai(
                'Frame',
                {
                    Position = UDim2.fromOffset(b1, b6), Size = UDim2.new(1, -b1 * 2, 0, b5),
                    BackgroundColor3 = z.Surface, BorderSizePixel = 0, Parent = b9
                }
            )
            cf:SetAttribute('NoDrag', true)
            aj(cf, UDim.new(0, 6))
            local cg = ak(cf)
            local ch, ci = aB(cf, 'search', z.Muted, UDim2.new(0, 9, 0.5, 0))
            ch.Size = UDim2.fromOffset(13, 13)
            ce = am(
                {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -9, 0, 0),
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = '',
                    TextSize = 11, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextTruncate = Enum.TextTruncate.None, Visible = false, Parent = cf
                }
            )
            cd = ai(
                'TextBox',
                {
                    Position = UDim2.fromOffset(29, 0), Size = UDim2.new(1, -90, 1, 0),
                    BackgroundTransparency = 1, Text = '',
                    PlaceholderText = bU.SearchPlaceholder or 'Search', PlaceholderColor3 = z.Muted,
                    TextColor3 = z.Text, TextSize = 12, FontFace = D.Regular,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd, ClearTextOnFocus = false, Parent = cf
                }
            )
            cd.Focused:Connect(
                function()
                    ah(cg, {Color = z.StrokeHover}, 0.15)
                    ah(ci, {ImageColor3 = z.Accent}, 0.15)
                end
            )
            cd.FocusLost:Connect(
                function()
                    ah(cg, {Color = z.Stroke}, 0.2)
                    ah(ci, {ImageColor3 = z.Muted}, 0.2)
                end
            )
        end
        local cf = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(b1, b7), Size = UDim2.new(1, -b1 * 2, 0, b_ + bY),
                BackgroundColor3 = z.Surface, BackgroundTransparency = 0.2, BorderSizePixel = 0,
                ClipsDescendants = true, Parent = b9
            }
        )
        aj(cf, UDim.new(0, 6))
        ak(cf, z.Stroke)
        local cg = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, b_), BackgroundColor3 = z.Surface3,
                BackgroundTransparency = 0.45, BorderSizePixel = 0, Parent = cf
            }
        )
        ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
                Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                Parent = cg
            }
        )
        local ch = ai(
            'ScrollingFrame',
            {
                Position = UDim2.fromOffset(0, b_), Size = UDim2.new(1, 0, 1, -b_),
                BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
                ScrollBarImageColor3 = z.Accent, ScrollBarImageTransparency = 0.4,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = cf
            }
        )
        ai('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder, Parent = ch})
        local ci = am(
            {
                Position = UDim2.fromOffset(0, b_), Size = UDim2.new(1, 0, 0, bY),
                Text = bU.EmptyText or 'Nothing here yet', TextSize = 12, FontFace = D.Regular,
                TextColor3 = z.Muted, TextXAlignment = Enum.TextXAlignment.Center, Parent = cf
            }
        )
        local cj = {Rows = {}}
        local ck = nil
        local cl, cm = {}, {}
        local cn = {}
        local co, cp = nil, false
        local cq = nil
        local cr = {
            Color3.fromRGB(245, 200, 90), Color3.fromRGB(200, 206, 218),
            Color3.fromRGB(214, 146, 96)
        }
        local function cs(ct)
            local cu = type(ct.Align) == 'string' and ct.Align:lower() or nil
            if cu == 'right' then
                return Enum.TextXAlignment.Right
            elseif cu == 'center' or cu == 'centre' then
                return Enum.TextXAlignment.Center
            end
            return Enum.TextXAlignment.Left
        end
        local function ct()
            local cu, cv, cw = 0, 0, 0
            for cx, cy in ipairs(cl) do
                local cz = tonumber(cy.Width)
                if cz and cz > 1 then
                    cu += cz
                elseif cz and cz > 0 then
                    cv += cz
                else
                    cw += 1
                end
            end
            local cx = math.max(1 - cv, 0)
            for cy, cz in ipairs(cl) do
                local cA = tonumber(cz.Width)
                local cB
                if cA and cA > 1 then
                    cz.UDim = UDim.new(0, cA)
                else
                    cB = (cA and cA > 0) and cA or (cw > 0 and cx / cw or 0)
                    cz.UDim = UDim.new(cB, -cu * cB)
                end
            end
        end
        local function cu(cv, cw)
            if cw.Rank then
                return nil
            end
            if cv[1] ~= nil or cw.Key == nil then
                return cv[cw.Index]
            end
            return cv[cw.Key]
        end
        local function cv(cw, cx, cy)
            if type(cx.Format) == 'function' then
                local cz, cA = pcall(cx.Format, cw, cy)
                if cz and cA ~= nil then
                    return tostring(cA)
                end
            end
            if type(cw) == 'number' then
                local cz = cw == math.floor(cw)
                local cA = cz and string.format('%d', cw) or string.format('%.2f', cw)
                local cB, cC, cD = cA:match('^(%-?)(%d+)(.*)$')
                if cC then
                    cC = cC:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
                    return cB .. cC .. cD
                end
                return cA
            end
            if cw == nil then
                return ''
            end
            return tostring(cw)
        end
        local function cw()
            for cx, cy in ipairs(cm) do
                local cz = cy.Column
                local cA = co ~= nil and co == cz
                ah(cy.Label, {TextColor3 = cA and z.Text or z.Muted}, 0.15)
                cy.Arrow.Visible = cA
                if cA then
                    ah(cy.Arrow, {Rotation = cp and 0 or 180}, 0.2, Enum.EasingStyle.Quint)
                end
            end
        end
        local function cx()
            local cy = {}
            for cz, cA in ipairs(cj.Rows) do
                cy[cz] = {Row = cA, Index = cz}
            end
            if co then
                local cz = co
                table.sort(
                    cy,
                    function(cA, cB)
                        local cC, cD = cu(cA.Row, cz), cu(cB.Row, cz)
                        local cE, cF = tonumber(cC), tonumber(cD)
                        if cE and cF then
                            if cE ~= cF then
                                if cp then
                                    return cE > cF
                                end
                                return cE < cF
                            end
                        elseif cC ~= nil and cD ~= nil then
                            local cG, cH = string.lower(tostring(cC)), string.lower(tostring(cD))
                            if cG ~= cH then
                                if cp then
                                    return cG > cH
                                end
                                return cG < cH
                            end
                        elseif cC ~= cD then
                            return cC ~= nil
                        end
                        return cA.Index < cB.Index
                    end
                )
            end
            for cz, cA in ipairs(cy) do
                cA.Rank = cz
            end
            if cc == '' then
                return cy
            end
            local cz = {}
            for cA, cB in ipairs(cy) do
                for cC, cD in ipairs(cl) do
                    if not cD.Rank then
                        local cE = cv(cu(cB.Row, cD), cD, cB.Row)
                        cE = string.lower((string.gsub(cE, '<[^>]->', '')))
                        if string.find(cE, cc, 1, true) then
                            table.insert(cz, cB)
                            break
                        end
                    end
                end
            end
            return cz
        end
        local function cy()
            local cz = ai(
                'TextButton',
                {
                    Size = UDim2.new(1, 0, 0, bY), BackgroundColor3 = z.Surface3,
                    BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false,
                    Text = '', Parent = ch
                }
            )
            local cA = ai(
                'Frame',
                {
                    Position = UDim2.new(0, 3, 0.5, 0), AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(0, 2, 1, -10), BackgroundColor3 = z.Accent,
                    BackgroundTransparency = 1, BorderSizePixel = 0, Parent = cz
                }
            )
            aj(cA, UDim.new(1, 0))
            local cB = ai(
                'Frame', {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = cz}
            )
            al(cB, 10, 10)
            ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder, Parent = cB
                }
            )
            local cC = {Frame = cz, Marker = cA, Cells = {}, Hover = false}
            for cD, cE in ipairs(cl) do
                local cF = ai(
                    'Frame',
                    {
                        Size = UDim2.new(cE.UDim.Scale, cE.UDim.Offset, 1, 0),
                        BackgroundTransparency = 1, LayoutOrder = cD, Parent = cB
                    }
                )
                local cG = am(
                    {
                        Size = UDim2.new(1, -6, 1, 0), TextSize = b0,
                        FontFace = cE.Rank and D.Bold or D.Regular, TextColor3 = z.Text,
                        TextXAlignment = cs(cE), RichText = not cE.Rank, Parent = cF
                    }
                )
                local cH
                if cE.Rank then
                    cG.Size = UDim2.fromScale(1, 1)
                    cG.TextXAlignment = Enum.TextXAlignment.Center
                    cH = ai(
                        'Frame',
                        {
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Position = UDim2.fromScale(0.5, 0.5),
                            Size = UDim2.fromOffset(bY - 8, bY - 8), BackgroundTransparency = 1,
                            BorderSizePixel = 0, ZIndex = 0, Parent = cF
                        }
                    )
                    aj(cH, UDim.new(1, 0))
                end
                cC.Cells[cD] = {Label = cG, Badge = cH}
            end
            local cD = ay(
                cz,
                function()
                    return ch
                end
            )
            cz.MouseEnter:Connect(
                function()
                    cC.Hover = true
                    ah(cz, {BackgroundTransparency = 0.35}, 0.1)
                end
            )
            cz.MouseLeave:Connect(
                function()
                    cC.Hover = false
                    ah(
                        cz,
                        {
                            BackgroundColor3 = cC.Highlighted and z.Accent or z.Surface3,
                            BackgroundTransparency = cC.Rest or 1
                        }, 0.2
                    )
                end
            )
            cz.MouseButton1Click:Connect(
                function()
                    if cC.Data and cD() then
                        aJ(bU.Callback, cC.Data, cC.Index)
                    end
                end
            )
            return cC
        end
        local function cz(cA)
            local cB = ck or #cj.Rows
            local cC = math.clamp(cB, 1, bZ)
            local cD = b_ + cC * bY
            local cE = b7 + cD + b8
            if cq == cE then
                return
            end
            local cF = (cA or cq == nil) and 0 or 0.25
            cq = cE
            ah(cf, {Size = UDim2.new(1, -b1 * 2, 0, cD)}, cF, Enum.EasingStyle.Quint)
            ah(b9, {Size = UDim2.new(1, 0, 0, cE)}, cF, Enum.EasingStyle.Quint)
        end
        local function cA()
            local cB = cx()
            for cC, cD in ipairs(cB) do
                local cE = cn[cC]
                if not cE then
                    cE = cy()
                    cn[cC] = cE
                end
                local cF = cD.Row
                cE.Data = cF
                cE.Index = cD.Index
                cE.Frame.LayoutOrder = cC
                cE.Frame.Visible = true
                local cG = cF.Highlight == true
                if not cG and type(bU.Highlight) == 'function' then
                    local cH, cI = pcall(bU.Highlight, cF, cD.Index)
                    cG = cH and cI == true
                end
                cE.Highlighted = cG
                cE.Rest = cG and 0.86 or (cC % 2 == 0 and 0.78 or 1)
                if not cE.Hover then
                    cE.Frame.BackgroundColor3 = cG and z.Accent or z.Surface3
                    cE.Frame.BackgroundTransparency = cE.Rest
                    aa(cE.Frame, {BackgroundColor3 = cE.Frame.BackgroundColor3})
                end
                cE.Marker.BackgroundTransparency = cG and 0 or 1
                for cH, cI in ipairs(cl) do
                    local cJ = cE.Cells[cH]
                    if cI.Rank then
                        local cK = cr[cD.Rank]
                        cJ.Label.Text = tostring(cD.Rank)
                        cJ.Label.TextColor3 = cK and Color3.fromRGB(28, 22, 18) or z.Muted
                        aa(cJ.Label, {TextColor3 = cJ.Label.TextColor3})
                        cJ.Badge.BackgroundColor3 = cK or z.Surface3
                        cJ.Badge.BackgroundTransparency = cK and 0.05 or 1
                    else
                        local cK = cu(cF, cI)
                        cJ.Label.Text = k._rich(cv(cK, cI, cF))
                        local cL = cI.Color
                        if type(cL) == 'function' then
                            local cM, cN = pcall(cL, cK, cF)
                            cL = cM and cN or nil
                        end
                        if type(cF.Colors) == 'table' then
                            local cM = cF.Colors[cI.Key or cI.Index]
                            if cM == nil then
                                cM = cF.Colors[cI.Index]
                            end
                            if cM ~= nil then
                                cL = cM
                            end
                        end
                        local cM = k._color(cL) or (cG and z.Accent or z.Text)
                        cJ.Label.TextColor3 = cM
                        aa(cJ.Label, {TextColor3 = cM})
                    end
                end
            end
            for cC = #cB + 1, #cn do
                cn[cC].Frame.Visible = false
                cn[cC].Data = nil
            end
            ck = #cB
            ci.Visible = #cB == 0
            ci.Text = (#cB == 0 and cc ~= '' and #cj.Rows > 0) and (bU.NoMatchText or 'No rows match') or (bU.EmptyText or 'Nothing here yet')
            if ce then
                ce.Visible = cc ~= ''
                ce.Text = #cB .. ' / ' .. #cj.Rows
            end
            cz()
        end
        local function cB()
            for cC, cD in ipairs(cm) do
                cD.Frame:Destroy()
            end
            table.clear(cm)
            for cC, cD in ipairs(cn) do
                cD.Frame:Destroy()
            end
            table.clear(cn)
            local cC = cg:FindFirstChild('Cells') or ai(
                'Frame',
                {Name = 'Cells', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = cg}
            )
            if not cC:FindFirstChildOfClass('UIListLayout') then
                al(cC, 10, 10)
                ai(
                    'UIListLayout',
                    {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder, Parent = cC
                    }
                )
            end
            for cD, cE in ipairs(cl) do
                local cF = ai(
                    'TextButton',
                    {
                        Size = UDim2.new(cE.UDim.Scale, cE.UDim.Offset, 1, 0),
                        BackgroundTransparency = 1, AutoButtonColor = false, Text = '',
                        LayoutOrder = cD, Parent = cC
                    }
                )
                local cG = cE.Rank and Enum.TextXAlignment.Center or cs(cE)
                local cH = cG == Enum.TextXAlignment.Right
                local cI = am(
                    {
                        Size = UDim2.new(1, cG == Enum.TextXAlignment.Center and 0 or -16, 1, 0),
                        Position = UDim2.fromOffset(cH and 16 or 0, 0),
                        Text = string.upper(cE.Name), TextSize = 11, FontFace = D.Bold,
                        TextColor3 = z.Muted, TextXAlignment = cG, Parent = cF
                    }
                )
                local cJ = ai(
                    'ImageLabel',
                    {
                        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1,
                        ImageColor3 = z.Accent, ScaleType = Enum.ScaleType.Fit, Visible = false,
                        Parent = cF
                    }
                )
                aq(cJ, 'chevron-down')
                local function cK()
                    local cL = cI.TextBounds.X
                    if cH then
                        cJ.Position = UDim2.new(1, -(cL + 15), 0.5, 0)
                    elseif cG == Enum.TextXAlignment.Center then
                        cJ.Position = UDim2.new(0.5, cL / 2 + 3, 0.5, 0)
                    else
                        local cM = cF.AbsoluteSize.X / math.max(bV.Scale.Scale, 0.01)
                        cJ.Position = UDim2.new(
                            0, math.clamp(cL + 4, 0, math.max(cM - 12, 0)), 0.5, 0
                        )
                    end
                end
                cI:GetPropertyChangedSignal('TextBounds'):Connect(cK)
                cF:GetPropertyChangedSignal('AbsoluteSize'):Connect(cK)
                task.defer(cK)
                local cL = cE.Sortable and not cE.Rank
                if cL then
                    cF.MouseEnter:Connect(
                        function()
                            if co ~= cE then
                                ah(cI, {TextColor3 = z.Text}, 0.12)
                            end
                        end
                    )
                    cF.MouseLeave:Connect(
                        function()
                            if co ~= cE then
                                ah(cI, {TextColor3 = z.Muted}, 0.2)
                            end
                        end
                    )
                    cF.MouseButton1Click:Connect(
                        function()
                            if co ~= cE then
                                local cM = false
                                for cN, cO in ipairs(cj.Rows) do
                                    local cP = cu(cO, cE)
                                    if cP ~= nil then
                                        cM = tonumber(cP) ~= nil
                                        break
                                    end
                                end
                                co, cp = cE, cM
                                cE.FirstDescending = cM
                            elseif cp == cE.FirstDescending then
                                cp = not cp
                            else
                                co = nil
                            end
                            cw()
                            cA()
                        end
                    )
                end
                table.insert(cm, {Frame = cF, Label = cI, Arrow = cJ, Column = cE})
            end
            cw()
        end
        function cj:SetColumns(cC)
            table.clear(cl)
            if bU.Rank then
                table.insert(
                    cl, {Name = '#', Rank = true, Width = E and 40 or 36, Sortable = false}
                )
            end
            for cD, cE in ipairs(type(cC) == 'table' and cC or {}) do
                if type(cE) ~= 'table' then
                    cE = {Name = tostring(cE)}
                end
                local cF = cE.Name or cE.Title or ('Column ' .. cD)
                table.insert(
                    cl,
                    {
                        Name = cF, Key = cE.Key or cF, Index = cD, Width = cE.Width,
                        Align = cE.Align, Format = cE.Format, Color = cE.Color,
                        Sortable = cE.Sortable ~= false and bU.Sortable ~= false
                    }
                )
            end
            co = nil
            ct()
            cB()
            cA()
        end
        local function cC(cD)
            if type(cD) == 'number' then
                return cl[cD + (bU.Rank and 1 or 0)]
            end
            for cE, cF in ipairs(cl) do
                if not cF.Rank and (cF.Key == cD or cF.Name == cD) then
                    return cF
                end
            end
            return nil
        end
        function cj:SetRows(cD)
            cj.Rows = {}
            for cE, cF in ipairs(type(cD) == 'table' and cD or {}) do
                cj.Rows[cE] = type(cF) == 'table' and cF or {cF}
            end
            cA()
        end
        cj.Set = cj.SetRows
        function cj:GetRows()
            return cj.Rows
        end
        cj.Get = cj.GetRows
        function cj:AddRow(cD, cE)
            cD = type(cD) == 'table' and cD or {cD}
            if tonumber(cE) then
                table.insert(cj.Rows, math.clamp(math.floor(cE), 1, #cj.Rows + 1), cD)
            else
                table.insert(cj.Rows, cD)
            end
            cA()
            return #cj.Rows
        end
        function cj:UpdateRow(cD, cE)
            if not cj.Rows[cD] then
                return false
            end
            cj.Rows[cD] = type(cE) == 'table' and cE or {cE}
            cA()
            for cF, cG in ipairs(cn) do
                if cG.Index == cD and cG.Frame.Visible then
                    local cH = cG.Highlighted and z.Accent or z.Surface3
                    ah(cG.Frame, {BackgroundColor3 = z.Accent, BackgroundTransparency = 0.7}, 0.08)
                    task.delay(
                        0.1,
                        function()
                            if not cG.Hover then
                                ah(
                                    cG.Frame,
                                    {BackgroundColor3 = cH, BackgroundTransparency = cG.Rest}, 0.5
                                )
                            end
                        end
                    )
                    break
                end
            end
            return true
        end
        function cj:RemoveRow(cD)
            if not cj.Rows[cD] then
                return false
            end
            table.remove(cj.Rows, cD)
            cA()
            return true
        end
        function cj:Clear()
            cj:SetRows({})
        end
        function cj:Sort(cD, cE)
            co = cD ~= nil and cC(cD) or nil
            cp = cE == true
            if co then
                co.FirstDescending = cp
            end
            cw()
            cA()
        end
        function cj:SetTitle(cD)
            if cb then
                cb.Text = tostring(cD)
            end
        end
        function cj:SetMaxRows(cD)
            bZ = math.max(math.floor(tonumber(cD) or bZ), 1)
            cz()
        end
        cj:SetColumns(bU.Columns or {})
        cj:SetRows(bU.Rows or {})
        if bU.SortBy ~= nil then
            cj:Sort(bU.SortBy, bU.SortDescending ~= false)
        end
        cz(true)
        if cd then
            cd:GetPropertyChangedSignal('Text'):Connect(
                function()
                    local cD = string.lower(bM(cd.Text))
                    if cD ~= cc then
                        cc = cD
                        ch.CanvasPosition = Vector2.zero
                        cA()
                    end
                end
            )
        end
        function cj:SetSearch(cD)
            if cd then
                cd.Text = tostring(cD or '')
            end
        end
        ag(cf, cA)
        return m(self, bU, cj, b9, 'Table')
    end
    aS.CreateImage = aS.Image
    aS.AddImage = aS.Image
    aS.CreateViewport = aS.Viewport
    aS.AddViewport = aS.Viewport
    aS.CreateTable = aS.Table
    aS.AddTable = aS.Table
    aS.CreateLeaderboard = aS.Table
    local function bU(bV)
        if bV.OutFrame then
            bV.OutFrame.Parent = bV.Area
            bV.OutFrame.Visible = false
            bV.OutFrame = nil
        end
        bV.Out.Visible = false
    end
    local function bV(bW)
        if bW.InFrame then
            bW.InFrame.Parent = bW.Area
            bW.InFrame.Position = UDim2.fromOffset(0, 0)
            bW.InFrame = nil
        end
        bW.In.Visible = false
    end
    function aS:_setupSubTabs()
        local bW = self._headerBottom
        local bX = self._page
        local bY = ai(
            'ScrollingFrame',
            {
                Name = 'SubTabs', Position = UDim2.fromOffset(24, bW - 4),
                Size = UDim2.new(1, -48, 0, 32), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X,
                AutomaticCanvasSize = Enum.AutomaticSize.X, CanvasSize = UDim2.new(), Parent = bX
            }
        )
        bY:SetAttribute('NoDrag', true)
        local bZ = ai(
            'Frame',
            {
                Size = UDim2.fromOffset(0, 32), BackgroundColor3 = z.Surface3,
                BackgroundTransparency = 0.35, BorderSizePixel = 0, Visible = false, Parent = bY
            }
        )
        aj(bZ, UDim.new(0, 8))
        ak(bZ, z.Stroke)
        local b_ = ai(
            'Frame',
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, ZIndex = 2, Parent = bY
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = b_
            }
        )
        self.Window:_overflowHint(bX, bY, b_, false, z.Background)
        local b0 = bW + 36
        local b1 = ai(
            'Frame',
            {
                Name = 'SubPages', Position = UDim2.fromOffset(0, b0),
                Size = UDim2.new(1, 0, 1, -b0), BackgroundTransparency = 1, ClipsDescendants = true,
                Parent = bX
            }
        )
        local b2 = {
            Strip = bY, Row = b_, Highlight = bZ, Area = b1,
            Out = ai(
                'CanvasGroup',
                {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = b1}
            ),
            In = ai(
                'CanvasGroup',
                {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 3, Parent = b1}
            ), Generation = 0
        }
        self._sub = b2
        self._subTabs = {}
        self.List.Visible = false
        self:_refreshEmpty()
        b_:GetPropertyChangedSignal('AbsoluteSize'):Connect(
            function()
                if self.CurrentSubTab and not b2.Moving then
                    self:_placeSubHighlight(self.CurrentSubTab, true)
                end
            end
        )
    end
    function aS:_placeSubHighlight(bW, bX)
        local bY = self._sub
        local bZ = self.Window.Scale.Scale
        local b_ = bW._button
        local b0 = b_.AbsoluteSize.X / bZ
        if b0 <= 0 then
            return
        end
        local b1 = (b_.AbsolutePosition.X - bY.Row.AbsolutePosition.X) / bZ
        local b2 = {Position = UDim2.fromOffset(b1, 0), Size = UDim2.fromOffset(b0, 32)}
        if bX or not bY.Highlight.Visible then
            bY.Highlight.Visible = true
            bY.Highlight.Position = b2.Position
            bY.Highlight.Size = b2.Size
        else
            bY.Moving = true
            ah(bY.Highlight, b2, 0.35, Enum.EasingStyle.Quint)
            task.delay(
                0.36,
                function()
                    bY.Moving = false
                end
            )
        end
        local b3 = bY.Strip.AbsoluteSize.X / bZ
        local b4 = bY.Strip.CanvasPosition.X
        if b1 < b4 then
            ah(
                bY.Strip, {CanvasPosition = Vector2.new(math.max(b1 - 8, 0), 0)}, 0.3,
                Enum.EasingStyle.Quint
            )
        elseif b1 + b0 > b4 + b3 then
            ah(
                bY.Strip, {CanvasPosition = Vector2.new(b1 + b0 - b3 + 8, 0)}, 0.3,
                Enum.EasingStyle.Quint
            )
        end
    end
    function aS:SubTab(bW, bX)
        if self._groupbox or self._isSubTab then
            return self.Parent:SubTab(bW, bX)
        end
        bW = l(bW, {Title = 'Name', Description = 'Desc'})
        if bX ~= nil and bW.Icon == nil then
            bW.Icon = bX
        end
        if not self._subTabs then
            self:_setupSubTabs()
        end
        local bY = self._sub
        local bZ = #self._subTabs + 1
        local b_ = setmetatable(
            {
                Name = bW.Name or ('Page ' .. bZ), Window = self.Window, Parent = self, _order = 0,
                _isSubTab = true, _index = bZ, _iconName = bW.Icon
            }, aS
        )
        local b0 = ai(
            'Frame',
            {
                Name = b_.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Visible = false, Parent = bY.Area
            }
        )
        b_._frame = b0
        bJ(
            b_, b0, 0, bW.Icon or self._iconName or 'layout-grid',
            bW.EmptyText or 'Nothing here yet'
        )
        local b1 = ai(
            'TextButton',
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Text = '', AutoButtonColor = false, LayoutOrder = bZ,
                Parent = bY.Row
            }
        )
        al(b1, 14, 14)
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = b1
            }
        )
        if bW.Icon then
            local b2 = ai(
                'ImageLabel',
                {
                    Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                    ImageColor3 = z.Muted, ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1,
                    Parent = b1
                }
            )
            aq(b2, bW.Icon)
            if b2:GetAttribute('CustomIcon') then
                b2.ImageTransparency = 0.4
            end
            b_._iconImage = b2
        end
        b_._label = am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = b_.Name,
                TextSize = 13, TextColor3 = z.Muted, TextTruncate = Enum.TextTruncate.None,
                LayoutOrder = 2, Parent = b1
            }
        )
        b_._button = b1
        b1.MouseEnter:Connect(
            function()
                if self.CurrentSubTab ~= b_ then
                    ah(b_._label, {TextColor3 = z.Text}, 0.12)
                end
            end
        )
        b1.MouseLeave:Connect(
            function()
                if self.CurrentSubTab ~= b_ then
                    ah(b_._label, {TextColor3 = z.Muted}, 0.2)
                end
            end
        )
        b1.MouseButton1Click:Connect(
            function()
                self:SelectSubTab(b_)
            end
        )
        table.insert(self._subTabs, b_)
        if bZ == 1 then
            self:SelectSubTab(b_, true)
        end
        return b_
    end
    aS.CreateSubTab = aS.SubTab
    aS.AddSubTab = aS.SubTab
    function aS:SelectSubTab(bW, bX)
        if type(bW) ~= 'table' then
            for bY, bZ in ipairs(self._subTabs or {}) do
                if bZ.Name == bW or bY == bW then
                    bW = bZ
                    break
                end
            end
        end
        if type(bW) ~= 'table' or not self._sub then
            return
        end
        local bY = self.CurrentSubTab
        if bY == bW then
            return
        end
        self.Window:_resetSearch()
        self.Window:_closePopups()
        self.CurrentSubTab = bW
        local bZ = self._sub
        bU(bZ)
        bV(bZ)
        bZ.Generation += 1
        local b_ = bZ.Generation
        local b0 = bX and 0 or 0.2
        if bY then
            ah(bY._label, {TextColor3 = z.Muted}, b0)
            if bY._iconImage then
                ar(bY._iconImage, z.Muted, false, b0)
            end
        end
        ah(bW._label, {TextColor3 = z.Text}, b0)
        if bW._iconImage then
            ar(bW._iconImage, z.Accent, true, b0)
        end
        self:_placeSubHighlight(bW, bX)
        if bX or not bY then
            if bY then
                bY._frame.Visible = false
            end
            bW._frame.Visible = true
            return
        end
        local b1 = bW._index > bY._index and 1 or -1
        bZ.OutFrame = bY._frame
        bY._frame.Parent = bZ.Out
        bZ.Out.GroupTransparency = 0
        bZ.Out.Position = UDim2.fromOffset(0, 0)
        bZ.Out.Visible = true
        ah(bZ.Out, {GroupTransparency = 1, Position = UDim2.fromOffset(-b1 * 28, 0)}, 0.2)
        bZ.InFrame = bW._frame
        bW._frame.Visible = true
        bW._frame.Parent = bZ.In
        bZ.In.GroupTransparency = 1
        bZ.In.Position = UDim2.fromOffset(b1 * 28, 0)
        bZ.In.Visible = true
        ah(
            bZ.In, {GroupTransparency = 0, Position = UDim2.fromOffset(0, 0)}, 0.34,
            Enum.EasingStyle.Quint
        )
        task.delay(
            0.2,
            function()
                if bZ.Generation == b_ then
                    bU(bZ)
                end
            end
        )
        task.delay(
            0.34,
            function()
                if bZ.Generation == b_ then
                    bV(bZ)
                end
            end
        )
    end
    a2._searchIcons = {
        Tab = 'app-window', Page = 'panels-top-left', Groupbox = 'layout-grid',
        Button = 'mouse-pointer-click', ButtonRow = 'mouse-pointer-click', Toggle = 'toggle-right',
        Slider = 'sliders-horizontal', Dropdown = 'list', Input = 'text-cursor-input',
        Keybind = 'keyboard', ColorPicker = 'palette', Stepper = 'chevrons-up-down',
        Progress = 'activity', Status = 'activity', StatusList = 'activity', Label = 'type',
        Paragraph = 'type', OrderList = 'list-ordered'
    }
    function a2:_searchResults(bW)
        local bX = {}
        local function bY(bZ, b_)
            if type(bZ) ~= 'string' or bZ == '' then
                return
            end
            local b0 = string.find(string.lower(bZ), bW, 1, true)
            if not b0 then
                return
            end
            b_.Name = bZ
            b_.At = b0
            b_.Rank = b0 == 1 and 0 or (string.find(string.sub(bZ, b0 - 1, b0 - 1), '[%s%p]') and 1 or 2)
            b_.Order = #bX + 1
            table.insert(bX, b_)
        end
        local function bZ(b_)
            return not b_._destroyed and b_._type ~= 'Section' and b_._type ~= 'Divider' and (b_._isShown == nil or b_:_isShown(
            ))
        end
        for b_, b0 in ipairs(self.Tabs) do
            bY(b0.Name, {Kind = 'Tab', Tab = b0, Icon = b0._iconName})
            for b1, b2 in ipairs(b0._subTabs or {b0}) do
                local b3 = b2._isSubTab and b2 or nil
                local b4 = b0.Name
                if b3 then
                    bY(b3.Name, {Kind = 'Page', Tab = b0, Sub = b3, Path = b0.Name})
                    b4 = b0.Name .. '  \u{203a}  ' .. b3.Name
                end
                if not b2._noSearch then
                    for b5, b6 in ipairs(b2._items or {}) do
                        if bZ(b6) then
                            bY(
                                b6._searchName,
                                {Kind = b6._type, Tab = b0, Sub = b3, Target = b6, Path = b4}
                            )
                        end
                    end
                    for b5, b6 in ipairs(b2._groupboxes or {}) do
                        if b6._userVisible ~= false then
                            bY(
                                b6.Name,
                                {Kind = 'Groupbox', Tab = b0, Sub = b3, Target = b6, Path = b4}
                            )
                            local b7 = b4 .. '  \u{203a}  ' .. b6.Name
                            for b8, b9 in ipairs(b6._items) do
                                if bZ(b9) then
                                    bY(
                                        b9._searchName,
                                        {Kind = b9._type, Tab = b0, Sub = b3, Target = b9, Group = b6, Path = b7}
                                    )
                                end
                            end
                        end
                    end
                end
            end
        end
        table.sort(
            bX,
            function(b_, b0)
                if b_.Rank ~= b0.Rank then
                    return b_.Rank < b0.Rank
                end
                return b_.Order < b0.Order
            end
        )
        return bX
    end
    function a2:_flash(bW, bX)
        for bY, bZ in ipairs({'SearchFlash', 'SearchGlow'}) do
            local b_ = bW:FindFirstChild(bZ)
            if b_ then
                b_:Destroy()
            end
        end
        bX = bX or 8
        local bY = z.Accent
        local bZ = bY:Lerp(Color3.new(1, 1, 1), 0.65)
        local b_ = ai(
            'Frame',
            {
                Name = 'SearchGlow', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                ZIndex = 10, Parent = bW
            }
        )
        aj(b_, UDim.new(0, bX))
        local b0 = ai(
            'UIStroke',
            {
                Color = bY, Thickness = 1, Transparency = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = b_
            }
        )
        local b1 = ai(
            'Frame',
            {
                Name = 'SearchFlash', Size = UDim2.fromScale(1, 1), BackgroundColor3 = bY,
                BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 10, Parent = bW
            }
        )
        aj(b1, UDim.new(0, bX))
        local b2 = ai(
            'UIGradient',
            {
                Transparency = NumberSequence.new(
                    {
                        NumberSequenceKeypoint.new(0, 0.7), NumberSequenceKeypoint.new(0.4, 0.55),
                        NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.6, 0.55),
                        NumberSequenceKeypoint.new(1, 0.7)
                    }
                ), Rotation = 18, Offset = Vector2.new(-1, 0), Parent = b1
            }
        )
        local b3 = ai(
            'UIStroke',
            {
                Color = Color3.new(1, 1, 1), Thickness = 1.6, Transparency = 1,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = b1
            }
        )
        local b4 = ai(
            'UIGradient',
            {
                Color = ColorSequence.new(
                    {
                        ColorSequenceKeypoint.new(0, bY), ColorSequenceKeypoint.new(0.5, bZ),
                        ColorSequenceKeypoint.new(1, bY)
                    }
                ),
                Transparency = NumberSequence.new(
                    {
                        NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(0.5, 0),
                        NumberSequenceKeypoint.new(1, 0.45)
                    }
                ), Parent = b3
            }
        )
        local b5 = pcall(
            function()
                b0.BorderStrokePosition = Enum.BorderStrokePosition.Inner
                b3.BorderStrokePosition = Enum.BorderStrokePosition.Inner
            end
        )
        local b6 = b5 and 6 or 3
        if not b5 then
            b_.Position = UDim2.fromOffset(b6 + 1, b6 + 1)
            b_.Size = UDim2.new(1, -(b6 + 1) * 2, 1, -(b6 + 1) * 2)
            b1.Position = UDim2.fromOffset(2, 2)
            b1.Size = UDim2.new(1, -4, 1, -4)
        end
        local b7
        if not bW:FindFirstChildOfClass('UIScale') then
            b7 = ai('UIScale', {Scale = 0.975, Parent = bW})
            ah(b7, {Scale = 1}, 0.4, Enum.EasingStyle.Quint)
        end
        ah(b1, {BackgroundTransparency = 0.8}, 0.2, Enum.EasingStyle.Quad)
        ah(b3, {Transparency = 0}, 0.2, Enum.EasingStyle.Quad)
        ah(b0, {Thickness = b6, Transparency = 0.72}, 0.35, Enum.EasingStyle.Quint)
        ah(b2, {Offset = Vector2.new(1, 0)}, 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        ah(b4, {Rotation = 540}, 2.2, Enum.EasingStyle.Quad)
        task.spawn(
            function()
                task.wait(0.75)
                ah(b1, {BackgroundTransparency = 0.9}, 0.35, Enum.EasingStyle.Sine)
                ah(b0, {Thickness = b6 / 2, Transparency = 0.85}, 0.35, Enum.EasingStyle.Sine)
                task.wait(0.35)
                ah(b1, {BackgroundTransparency = 0.84}, 0.3, Enum.EasingStyle.Sine)
                ah(b0, {Thickness = b6 * 0.85, Transparency = 0.76}, 0.3, Enum.EasingStyle.Sine)
                task.wait(0.4)
                ah(b1, {BackgroundTransparency = 1}, 0.55, Enum.EasingStyle.Quad)
                ah(b3, {Transparency = 1}, 0.65, Enum.EasingStyle.Quad)
                ah(b0, {Thickness = b6, Transparency = 1}, 0.65, Enum.EasingStyle.Quad)
                task.wait(0.7)
                b1:Destroy()
                b_:Destroy()
                if b7 then
                    b7:Destroy()
                end
            end
        )
    end
    function a2:_revealResult(bW)
        local bX, bY, bZ, b_ = bW.Tab, bW.Sub, bW.Target, bW.Group
        if self.CurrentTab ~= bX then
            self:SelectTab(bX)
        end
        if bY then
            bX:SelectSubTab(bY)
        end
        if not bZ then
            local b0 = bY and bY._button or bX._button
            task.delay(
                0.1,
                function()
                    if b0.Parent then
                        self:_flash(b0, bY and 8 or 10)
                    end
                end
            )
            return
        end
        local b0 = b_ ~= nil and b_:IsCollapsed()
        if b0 then
            b_:Expand()
        end
        local b1 = (bY or bX).List
        task.spawn(
            function()
                task.wait()
                task.wait()
                if b0 then
                    task.wait(0.3)
                end
                local b2 = bZ._frame
                if self._destroyed or bZ._destroyed or not b2 or not b2.Parent or not b1 then
                    return
                end
                local b3 = self.Scale.Scale
                local b4 = (b2.AbsolutePosition.Y - b1.AbsolutePosition.Y) / b3 + b1.CanvasPosition.Y
                local b5 = b2.AbsoluteSize.Y / b3
                local b6 = b1.AbsoluteWindowSize.Y / b3
                local b7 = math.max(b1.AbsoluteCanvasSize.Y / b3 - b6, 0)
                local b8 = math.clamp(b4 + b5 / 2 - b6 / 2, 0, b7)
                if math.abs(b8 - b1.CanvasPosition.Y) > 2 then
                    ah(b1, {CanvasPosition = Vector2.new(0, b8)}, 0.45, Enum.EasingStyle.Quint)
                    task.wait(0.25)
                end
                if b2.Parent then
                    self:_flash(b2, bZ._groupbox and 10 or 8)
                end
            end
        )
    end
    function a2:_resetSearch()
        if self.SearchBox and self.SearchBox.Text ~= '' then
            self.SearchBox.Text = ''
        end
    end
    function a2:_fitTitle(bW)
        local bX = self.SearchBox and (self._searchWidth or N) + 72 or 56
        local bY = bW._titleX + bX
        bW._title.Size = UDim2.new(1, -bY, 0, 24)
        if bW._desc then
            bW._desc.Size = UDim2.new(1, -bY, 0, 16)
        end
    end
    function a2:_buildSearch(bW)
        local bX = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -56, 0, 14),
                Size = UDim2.fromOffset(N, 34), BackgroundTransparency = 1, BorderSizePixel = 0,
                ZIndex = 5, Parent = bW
            }
        )
        bX:SetAttribute('NoDrag', true)
        local bY = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                Parent = bX
            }
        )
        local bZ = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -1),
                Size = UDim2.new(0, 0, 0, 2), BackgroundColor3 = z.Accent, BorderSizePixel = 0,
                ZIndex = 2, Parent = bX
            }
        )
        aj(bZ, UDim.new(1, 0))
        local b_, b0 = aB(bX, 'search', z.Muted, UDim2.new(0, 2, 0.5, -1))
        b0.Parent.Size = UDim2.fromOffset(15, 15)
        local b1 = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(26, 0), Size = UDim2.new(1, -28, 1, -2),
                BackgroundTransparency = 1, Text = '', PlaceholderText = 'Search',
                PlaceholderColor3 = z.Muted, TextColor3 = z.Text, TextSize = 13,
                FontFace = D.Regular, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ClearTextOnFocus = false, Parent = bX
            }
        )
        bX.MouseEnter:Connect(
            function()
                if not b1:IsFocused() then
                    ah(bY, {BackgroundColor3 = z.StrokeHover}, 0.15)
                end
            end
        )
        bX.MouseLeave:Connect(
            function()
                ah(bY, {BackgroundColor3 = z.Stroke}, 0.25)
            end
        )
        self.SearchBox = b1
        local b2 = E and 40 or 34
        local b3 = 8
        local b4 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0), Size = UDim2.fromOffset(300, 0),
                BackgroundTransparency = 1, Visible = false, ZIndex = 45, Parent = self.Body
            }
        )
        b4:SetAttribute('NoDrag', true)
        local b5 = ai(
            'ImageLabel',
            {
                Position = UDim2.fromOffset(-18, -12), Size = UDim2.new(1, 36, 1, 36),
                BackgroundTransparency = 1, Image = A.Shadow, ImageColor3 = Color3.new(0, 0, 0),
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450), Parent = b4
            }
        )
        local b6 = ai(
            'Frame',
            {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = z.Background, BorderSizePixel = 0,
                ClipsDescendants = true, Parent = b4
            }
        )
        aj(b6, UDim.new(0, 10))
        local b7 = ak(b6, z.Stroke, 1)
        ao(b6)
        local b8 = ai(
            'ScrollingFrame',
            {
                Position = UDim2.fromOffset(6, 6), Size = UDim2.new(1, -12, 1, -12),
                BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = E and 4 or 3,
                ScrollBarImageColor3 = z.Accent, ScrollBarImageTransparency = 0.4,
                ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(),
                Parent = b6
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b8}
        )
        local b9 = am(
            {
                Size = UDim2.new(1, 0, 0, b2), Text = 'No results', TextSize = 13,
                FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 0, Visible = false,
                Parent = b8
            }
        )
        local ca = {}
        local cb = {}
        local cc = 1
        local cd = false
        local ce = 0
        local cf = Vector2.new(300, 0)
        local cg = nil
        local ch
        local function ci()
            local cj = self.Scale.Scale
            local ck = self.Body.AbsolutePosition
            local cl = self.Body.AbsoluteSize.X / cj
            local cm = (bX.AbsolutePosition.X + bX.AbsoluteSize.X - ck.X) / cj
            local cn = (bX.AbsolutePosition.Y + bX.AbsoluteSize.Y - ck.Y) / cj + 6
            cm = math.clamp(cm, cf.X + 8, math.max(cl - 8, cf.X + 8))
            b4.Position = UDim2.fromOffset(cm, cn)
        end
        local function cj()
            local ck = self.Scale.Scale
            local cl = self.Body.AbsoluteSize / ck
            local cm = (bX.AbsolutePosition.Y + bX.AbsoluteSize.Y - self.Body.AbsolutePosition.Y) / ck + 6
            local cn = math.max(#ca, 1)
            local co = math.min(cn, b3) * (b2 + 2) - 2 + 12
            co = math.max(math.min(co, cl.Y - cm - 12), b2 + 12)
            local cp = math.min(math.max(bX.AbsoluteSize.X / ck, 300), math.max(cl.X - 16, 160))
            cf = Vector2.new(cp, co)
        end
        local function ck()
            for cl, cm in ipairs(ca) do
                local cn = cl == cc
                ah(cm.Button, {BackgroundTransparency = cn and 0.35 or 1}, 0.12)
                ar(cm.Icon, cn and z.Accent or z.Muted, cn, 0.12)
            end
        end
        local function cl()
            local cm = (cc - 1) * (b2 + 2)
            local cn = b8.AbsoluteWindowSize.Y / self.Scale.Scale
            local co = b8.CanvasPosition.Y
            if cm < co then
                co = cm
            elseif cm + b2 > co + cn then
                co = cm + b2 - cn
            else
                return
            end
            b8.CanvasPosition = Vector2.new(0, math.max(co, 0))
        end
        local function cm(cn)
            if cn == cd then
                return
            end
            cd = cn
            ce += 1
            local co = ce
            if cn then
                if self._closePopup and self._closePopup ~= ch then
                    self._closePopup()
                end
                self._closePopup = ch
                ci()
                b4.Size = UDim2.fromOffset(cf.X, 0)
                b4.Visible = true
                ah(b4, {Size = UDim2.fromOffset(cf.X, cf.Y)}, 0.26, Enum.EasingStyle.Quint)
                ah(b7, {Transparency = 0}, 0.12)
                ah(b5, {ImageTransparency = 0.55}, 0.26)
                if not cg then
                    cg = self:_listen('Render', ci)
                end
            else
                if self._closePopup == ch then
                    self._closePopup = nil
                end
                ah(b4, {Size = UDim2.fromOffset(cf.X, 0)}, 0.18, Enum.EasingStyle.Quint)
                ah(b5, {ImageTransparency = 1}, 0.14)
                task.delay(
                    0.19,
                    function()
                        if ce == co and not cd then
                            b4.Visible = false
                            b7.Transparency = 1
                            if cg then
                                cg()
                                cg = nil
                            end
                        end
                    end
                )
            end
        end
        ch = function()
            cm(false)
        end
        local function cn(co)
            if not co then
                return
            end
            cm(false)
            b1.Text = ''
            if b1:IsFocused() then
                b1:ReleaseFocus()
            end
            self:_revealResult(co)
        end
        local function co(cp)
            return (string.gsub(
                string.gsub(string.gsub(cp, '&', '&amp;'), '<', '&lt;'), '>', '&gt;'
            ))
        end
        local function cp(cq)
            for cr, cs in ipairs(ca) do
                cs.Button:Destroy()
            end
            table.clear(ca)
            cb = self:_searchResults(cq)
            cc = 1
            local cr = bc(z.Accent)
            for cs, ct in ipairs(cb) do
                if cs > 50 then
                    break
                end
                local cu = ai(
                    'TextButton',
                    {
                        Size = UDim2.new(1, 0, 0, b2), BackgroundColor3 = z.Surface3,
                        BackgroundTransparency = 1, Text = '', AutoButtonColor = false,
                        LayoutOrder = cs, Parent = b8
                    }
                )
                aj(cu, UDim.new(0, 7))
                local cv = ai(
                    'Frame',
                    {
                        Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0),
                        BackgroundTransparency = 1, ClipsDescendants = true, Parent = cu
                    }
                )
                ai(
                    'UIListLayout',
                    {
                        FillDirection = Enum.FillDirection.Horizontal,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5),
                        Parent = cv
                    }
                )
                local cw = 0
                local cx = nil
                local function cy(cz)
                    if not cz then
                        return
                    end
                    cw += 1
                    local cA = ai(
                        'ImageLabel',
                        {
                            Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                            ImageColor3 = z.Muted, ScaleType = Enum.ScaleType.Fit, LayoutOrder = cw,
                            Parent = cv
                        }
                    )
                    aq(cA, cz)
                    cx = cx or cA
                end
                local function cz(cA, cB, cC)
                    cw += 1
                    return am(
                        {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            Text = cA, RichText = cC == true, TextSize = 13,
                            FontFace = cB and D.Medium or D.Regular, TextColor3 = cB or z.Muted,
                            TextTruncate = Enum.TextTruncate.None, LayoutOrder = cw, Parent = cv
                        }
                    )
                end
                local function cA()
                    cz('>')
                end
                local cB, cC, cD = ct.Tab, ct.Sub, ct.Group
                local cE = ct.Kind == 'Tab'
                local cF = ct.Kind == 'Page'
                local cG = ct.Kind == 'Groupbox'
                cy(cB._iconName or 'layout-grid')
                if not cE then
                    cz(cB.Name)
                    if cC then
                        cA()
                        cy(cC._iconName or 'layers')
                        if not cF then
                            cz(cC.Name)
                        end
                    end
                    if cD and not cG then
                        cA()
                        cz(cD.Name)
                    end
                    if not cF then
                        cA()
                    end
                end
                local cH = ct.Name
                local cI = ct.At + #cq
                local cJ = co(string.sub(cH, 1, ct.At - 1)) .. '<b>' .. co(
                    string.sub(cH, ct.At, cI - 1)
                ) .. '</b>' .. co(string.sub(cH, cI))
                cz(cJ, z.Accent, true)
                local cK = cx
                local cL = ay(
                    cu,
                    function()
                        return b8
                    end
                )
                cu.MouseEnter:Connect(
                    function()
                        if not ax() then
                            cc = cs
                            ck()
                        end
                    end
                )
                cu.MouseButton1Click:Connect(
                    function()
                        if cL() then
                            cn(ct)
                        end
                    end
                )
                table.insert(ca, {Button = cu, Icon = cK})
            end
            b9.Visible = #ca == 0
            b8.CanvasSize = UDim2.fromOffset(0, math.max(#ca, 1) * (b2 + 2) - 2)
            b8.CanvasPosition = Vector2.zero
            ck()
            cj()
            if cd then
                ci()
                ah(b4, {Size = UDim2.fromOffset(cf.X, cf.Y)}, 0.2, Enum.EasingStyle.Quint)
            end
        end
        local function cq()
            local cr = string.match(string.lower(b1.Text), '^%s*(.-)%s*$')
            if cr == '' then
                cm(false)
                return
            end
            cp(cr)
            cm(true)
        end
        b1.Focused:Connect(
            function()
                ah(bZ, {Size = UDim2.new(1, 0, 0, 2)}, 0.35, Enum.EasingStyle.Quint)
                ah(b0, {ImageColor3 = z.Accent}, 0.15)
                if b1.Text ~= '' then
                    cq()
                end
            end
        )
        b1.FocusLost:Connect(
            function(cr)
                ah(bZ, {Size = UDim2.new(0, 0, 0, 2)}, 0.3, Enum.EasingStyle.Quint)
                ah(b0, {ImageColor3 = z.Muted}, 0.2)
                if cr and cd then
                    cn(cb[cc])
                end
            end
        )
        b1:GetPropertyChangedSignal('Text'):Connect(cq)
        self:_listen(
            'Began',
            function(cr)
                if not cd then
                    return
                end
                if cr.KeyCode == Enum.KeyCode.Up or cr.KeyCode == Enum.KeyCode.Down then
                    if #ca > 0 then
                        local cs = cr.KeyCode == Enum.KeyCode.Up and -1 or 1
                        cc = math.clamp(cc + cs, 1, #ca)
                        ck()
                        cl()
                    end
                elseif cr.KeyCode == Enum.KeyCode.Escape then
                    cm(false)
                elseif aw(cr) then
                    local cs = av()
                    if not az(cs, b4) and not az(cs, bX) then
                        cm(false)
                    end
                end
            end
        )
        local function cr()
            local cs = bW.AbsoluteSize.X / self.Scale.Scale
            local ct = math.clamp(math.floor(cs * 0.32), 110, N)
            bX.Size = UDim2.fromOffset(ct, 34)
            if ct ~= self._searchWidth then
                self._searchWidth = ct
                for cu, cv in ipairs(self.Tabs) do
                    self:_fitTitle(cv)
                end
            end
        end
        bW:GetPropertyChangedSignal('AbsoluteSize'):Connect(cr)
        task.defer(cr)
    end
    function a2:_trackName(bW, bX)
        table.insert(self._identity.Names, {Label = bW, Kind = bX})
        self:_renderIdentity()
    end
    function a2:_trackAvatar(bW, bX)
        table.insert(self._identity.Avatars, {Image = bW, Placeholder = bX})
        self:_renderIdentity(true)
    end
    function a2:_renderIdentity(bW)
        for bX, bY in ipairs(self._identity.Names) do
            if bY.Kind == 'User' then
                bY.Label.Text = self._hideName and '@hidden' or ('@' .. j.Name)
            else
                bY.Label.Text = self._hideName and 'Hidden' or j.DisplayName
            end
        end
        local bX = bW and 0 or 0.2
        for bY, bZ in ipairs(self._identity.Avatars) do
            ah(bZ.Image, {ImageTransparency = self._hideAvatar and 1 or 0}, bX)
            ah(bZ.Placeholder, {ImageTransparency = self._hideAvatar and 0.2 or 1}, bX)
        end
    end
    function a2:SetHideName(bW)
        self._hideName = bW == true
        self:_renderIdentity()
    end
    function a2:SetHideAvatar(bW)
        self._hideAvatar = bW == true
        self:_renderIdentity()
    end
    local function bW(bX, bY, bZ, b_, b0, b1)
        local b2 = ai('Frame', {BackgroundColor3 = z.Surface3, BorderSizePixel = 0, Parent = bY})
        for b3, b4 in pairs(bZ) do
            b2[b3] = b4
        end
        aj(b2, UDim.new(1, 0))
        ak(b2, b_ or z.Stroke, b0 or 0, b1 or 1)
        local b3 = ai(
            'ImageLabel',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Image = 'rbxthumb://type=AvatarHeadShot&id=' .. tostring(j.UserId) .. '&w=150&h=150',
                Parent = b2
            }
        )
        aj(b3, UDim.new(1, 0))
        local b4 = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(0.45, 0.45), BackgroundTransparency = 1,
                ImageColor3 = z.Muted, ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit,
                Parent = b2
            }
        )
        aq(b4, 'user')
        bX:_trackAvatar(b3, b4)
        return b2
    end
    function a2:_buildProfile(bX)
        ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -M),
                Size = UDim2.new(1, -20, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                Parent = bX
            }
        )
        local bY = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -8),
                Size = UDim2.new(1, -16, 0, M - 16), BackgroundColor3 = z.Surface2,
                BackgroundTransparency = 0, Text = '', AutoButtonColor = false, Parent = bX
            }
        )
        aj(bY, UDim.new(0, 8))
        local bZ = ak(bY, z.Stroke, 0)
        local b_ = bW(
            self, bY,
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 8, 0.5, 0),
                Size = UDim2.fromOffset(32, 32)
            }
        )
        local b0 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 1, 1, 1),
                Size = UDim2.fromOffset(9, 9), BackgroundColor3 = z.Success, BorderSizePixel = 0,
                ZIndex = 2, Parent = b_
            }
        )
        aj(b0, UDim.new(1, 0))
        ak(b0, z.Surface2, 0, 2)
        local b1 = am(
            {
                Position = UDim2.new(0, 48, 0.5, -15), Size = UDim2.new(1, -74, 0, 15),
                TextSize = 12, FontFace = D.Bold, Parent = bY
            }
        )
        self:_trackName(b1, 'Display')
        local b2 = am(
            {
                Position = UDim2.new(0, 48, 0.5, 1), Size = UDim2.new(1, -74, 0, 13),
                Text = '\u{2026}', TextSize = 11, FontFace = D.Regular, TextColor3 = z.Muted,
                Parent = bY
            }
        )
        local b3 = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ScaleType = Enum.ScaleType.Fit, Parent = bY
            }
        )
        aq(b3, 'chevron-right')
        task.spawn(
            function()
                b2.Text = aZ()
            end
        )
        bY.MouseEnter:Connect(
            function()
                if ax() then
                    return
                end
                ah(bZ, {Color = z.StrokeHover}, 0.12)
                ah(b3, {ImageColor3 = z.Text, Position = UDim2.new(1, -6, 0.5, 0)}, 0.15)
            end
        )
        bY.MouseLeave:Connect(
            function()
                ah(bZ, {Color = z.Stroke}, 0.2)
                ah(b3, {ImageColor3 = z.Muted, Position = UDim2.new(1, -8, 0.5, 0)}, 0.2)
            end
        )
        bY.MouseButton1Click:Connect(
            function()
                if self.Home then
                    self:SelectTab(self.Home)
                end
            end
        )
        self.Profile = bY
    end
    function a2:Rejoin()
        self:Notify(
            {
                Title = 'Rejoining', Content = 'Teleporting back into this server',
                Icon = 'refresh-cw', Duration = 3
            }
        )
        task.spawn(
            function()
                local bX, bY = pcall(
                    function()
                        if #f:GetPlayers() <= 1 or game.JobId == '' then
                            g:Teleport(game.PlaceId, j)
                        else
                            g:TeleportToPlaceInstance(game.PlaceId, game.JobId, j)
                        end
                    end
                )
                if not bX then
                    self:Notify(
                        {Title = 'Rejoin failed', Content = tostring(bY), Type = 'Error', Duration = 4}
                    )
                end
            end
        )
    end
    local function bX(bY, bZ, b_, b0)
        task.spawn(
            function()
                local b1 = bD(bZ)
                if not b1 then
                    bY:Notify(
                        {Title = b0 .. ' failed', Content = 'Could not load the server list', Type = 'Error', Duration = 4}
                    )
                    return
                end
                local b2 = {}
                for b3, b4 in ipairs(b1) do
                    if type(b4) == 'table' and b4.id ~= game.JobId then
                        local b5, b6 = tonumber(b4.playing), tonumber(b4.maxPlayers)
                        if b5 and b6 and b5 < b6 then
                            table.insert(b2, b4)
                        end
                    end
                end
                local b3 = #b2 > 0 and b_(b2) or nil
                if not b3 then
                    bY:Notify(
                        {Title = b0 .. ' failed', Content = 'No other open server found', Type = 'Warning', Duration = 4}
                    )
                    return
                end
                bY:Notify(
                    {
                        Title = b0,
                        Content = string.format(
                            'Joining a server with %d/%d players', b3.playing, b3.maxPlayers
                        ), Icon = 'server', Duration = 3
                    }
                )
                local b4, b5 = pcall(
                    function()
                        g:TeleportToPlaceInstance(game.PlaceId, b3.id, j)
                    end
                )
                if not b4 then
                    bY:Notify(
                        {Title = b0 .. ' failed', Content = tostring(b5), Type = 'Error', Duration = 4}
                    )
                end
            end
        )
    end
    function a2:ServerHop()
        bX(
            self, 'Desc',
            function(bY)
                return bY[math.random(1, #bY)]
            end, 'Server hop'
        )
    end
    function a2:JoinLowestServer()
        bX(
            self, 'Asc',
            function(bY)
                table.sort(
                    bY,
                    function(bZ, b_)
                        return bZ.playing < b_.playing
                    end
                )
                return bY[1]
            end, 'Lowest server'
        )
    end
    function a2:CopyToClipboard(bY, bZ)
        local b_ = bC(bY)
        self:Notify(
            {
                Title = b_ and 'Copied' or 'Clipboard unavailable',
                Content = b_ and (bZ or tostring(bY)) or 'Your executor has no setclipboard',
                Type = b_ and 'Success' or 'Error', Icon = b_ and 'clipboard-check' or nil,
                Duration = 2.5
            }
        )
        return b_
    end
    function a2:_homeCard(bY, bZ)
        local b_ = bG(bY, 0, bZ)
        b_.AutomaticSize = Enum.AutomaticSize.Y
        al(b_, 16, 16, 14, 14)
        ai('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder, Parent = b_})
        return b_
    end
    function a2:_homeCaption(bY, bZ, b_)
        return am(
            {
                Size = UDim2.new(1, 0, 0, 22), Text = string.upper(bZ), TextSize = 10,
                TextColor3 = z.Muted, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = b_,
                Parent = bY
            }
        )
    end
    function a2:_homeChip(bY, bZ, b_, b0, b1)
        local b2 = ai(
            'TextButton',
            {
                Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = z.Surface3, BackgroundTransparency = 0.2, BorderSizePixel = 0,
                Text = '', AutoButtonColor = false, LayoutOrder = bZ, Parent = bY
            }
        )
        aj(b2, UDim.new(0, 6))
        local b3 = ak(b2)
        al(b2, 8, 9)
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = b2
            }
        )
        local b4 = ai(
            'ImageLabel',
            {
                Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1,
                ImageColor3 = b1 or z.Muted, ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1,
                Parent = b2
            }
        )
        aq(b4, b_)
        local b5 = am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = b0,
                TextSize = 12, TextColor3 = b1 or z.Muted, TextTruncate = Enum.TextTruncate.None,
                LayoutOrder = 2, Parent = b2
            }
        )
        return b2, b5, b4, b3
    end
    function a2:_homeToggleChip(bY, bZ, b_, b0, b1, b2)
        local b3, b4, b5, b6 = self:_homeChip(bY, bZ, b_, b0)
        local b7 = b1 == true
        local function b8(b9)
            ah(
                b3,
                {BackgroundColor3 = b7 and z.Accent or z.Surface3, BackgroundTransparency = b7 and 0.85 or 0.2},
                b9
            )
            ah(b6, {Color = b7 and z.Accent or z.Stroke, Transparency = b7 and 0.6 or 0}, b9)
            ah(b4, {TextColor3 = b7 and z.Accent or z.Muted}, b9)
            ah(b5, {ImageColor3 = b7 and z.Accent or z.Muted}, b9)
        end
        b8(0)
        b3.MouseButton1Click:Connect(
            function()
                b7 = not b7
                b8(0.2)
                aJ(b2, b7)
            end
        )
        return b3
    end
    function a2:_homeProfile(bY, bZ, b_)
        local b0 = bG(bY, 140, b_)
        b0.ClipsDescendants = true
        local b1 = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, 0),
                Size = UDim2.fromOffset(140, 140), BackgroundTransparency = 1,
                Image = 'rbxthumb://type=AvatarBust&id=' .. tostring(j.UserId) .. '&w=420&h=420',
                ScaleType = Enum.ScaleType.Fit, Parent = b0
            }
        )
        ai(
            'UIGradient',
            {
                Transparency = NumberSequence.new(
                    {
                        NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 0),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                ), Parent = b1
            }
        )
        local b2 = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.6, 0.55),
                Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit, Parent = b1
            }
        )
        aq(b2, 'user')
        self:_trackAvatar(b1, b2)
        local b3 = UDim2.new(1, -190, 0, 0)
        am(
            {
                Position = UDim2.fromOffset(22, 20), Size = b3 + UDim2.fromOffset(0, 14),
                Text = string.upper(bZ.Welcome or 'Welcome back'), TextSize = 10,
                TextColor3 = z.Muted, Parent = b0
            }
        )
        local b4 = am(
            {
                Position = UDim2.fromOffset(22, 35), Size = b3 + UDim2.fromOffset(0, 32),
                TextSize = 26, FontFace = D.Bold, Parent = b0
            }
        )
        self:_trackName(b4, 'Display')
        local b5 = am(
            {
                Position = UDim2.fromOffset(22, 67), Size = b3 + UDim2.fromOffset(0, 16),
                TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted, Parent = b0
            }
        )
        self:_trackName(b5, 'User')
        local b6 = ai(
            'Frame',
            {
                Position = UDim2.new(0, 22, 1, -40), Size = UDim2.new(1, -44, 0, 24),
                BackgroundTransparency = 1, Parent = b0
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = b6
            }
        )
        local b7 = bZ.Tier
        if b7 == nil then
            b7 = 'Free'
        end
        if b7 then
            local b8, b9, ca = self:_homeChip(
                b6, 1, bZ.TierIcon or self._logoIcon, tostring(b7), z.Accent
            )
            b8.Active = false
            b9.FontFace = D.Bold
            ca.Size = UDim2.fromOffset(13, 13)
            self.TierLabel = b9
        end
        local b8, b9 = self:_homeChip(b6, 2, 'clock', '')
        b8.Active = false
        b8.Visible = false
        self:_homeToggleChip(
            b6, 3, 'eye-off', 'Name', self._hideName,
            function(ca)
                self:SetHideName(ca)
            end
        )
        self:_homeToggleChip(
            b6, 4, 'user-x', 'Avatar', self._hideAvatar,
            function(ca)
                self:SetHideAvatar(ca)
            end
        )
        return function()
            local ca = bZ.Expiry
            if type(ca) == 'function' then
                local cb, cc = pcall(ca)
                ca = cb and cc or nil
            end
            if type(ca) == 'number' then
                local cb = ca - os.time()
                b9.Text = cb > 0 and (bA(cb) .. ' left') or 'Expired'
            elseif ca ~= nil then
                b9.Text = tostring(ca)
            end
            b8.Visible = b9.Text ~= ''
        end
    end
    function a2:_homeGraph(bY, bZ, b_, b0, b1)
        local b2 = ai('Frame', {BackgroundTransparency = 1, LayoutOrder = bZ, Parent = bY})
        local b3 = aB(b2, b_, z.Muted, UDim2.new(0, 0, 0, 7))
        b3.Size = UDim2.fromOffset(12, 12)
        am(
            {
                Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -18, 0, 14),
                Text = string.upper(b0), TextSize = 10, TextColor3 = z.Muted, Parent = b2
            }
        )
        local b4 = am(
            {
                Position = UDim2.fromOffset(0, 16), Size = UDim2.new(1, 0, 0, 28),
                Text = '\u{2026}', TextSize = 24, FontFace = D.Bold, RichText = true, Parent = b2
            }
        )
        local b5 = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(0, 50), Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1, Parent = b2
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = b5
            }
        )
        local b6 = 24
        local b7, b8 = {}, {}
        for b9 = 1, b6 do
            local ca = ai(
                'Frame',
                {
                    Size = UDim2.new(1 / b6, -2, 0, 2), BackgroundColor3 = z.Surface3,
                    BorderSizePixel = 0, LayoutOrder = b9, Parent = b5
                }
            )
            aj(ca, UDim.new(0, 2))
            b7[b9] = ca
        end
        local function b9(ca, cb)
            table.insert(b8, ca)
            if #b8 > b6 then
                table.remove(b8, 1)
            end
            local cc = b1 or 1
            for cd, ce in ipairs(b8) do
                cc = math.max(cc, ce)
            end
            local cd = b6 - #b8
            for ce, cf in ipairs(b7) do
                local cg = b8[ce - cd]
                local ch = ce == b6
                local ci = cg and math.max(cg / cc, 0.08) or 0
                ah(
                    cf,
                    {
                        Size = UDim2.new(1 / b6, -2, ci, cg and 0 or 2),
                        BackgroundColor3 = (ch and cb) or (cg and z.Muted or z.Surface3),
                        BackgroundTransparency = ch and 0 or (cg and 0.6 or 0)
                    }, 0.35, Enum.EasingStyle.Quint
                )
            end
        end
        return b4, b9
    end
    function a2:_homeFigure(bY, bZ, b_)
        local b0 = ai('Frame', {BackgroundTransparency = 1, LayoutOrder = bZ, Parent = bY})
        local b1 = am(
            {
                Size = UDim2.new(1, -8, 0, 20), Text = '\u{2026}', TextSize = 15, FontFace = D.Bold,
                RichText = true, Parent = b0
            }
        )
        am(
            {
                Position = UDim2.fromOffset(0, 21), Size = UDim2.new(1, -8, 0, 14),
                Text = string.upper(b_), TextSize = 10, TextColor3 = z.Muted, Parent = b0
            }
        )
        return b1
    end
    function a2:_homeAction(bY, bZ, b_, b0, b1)
        local b2 = ai(
            'TextButton',
            {
                BackgroundColor3 = z.Surface3, BackgroundTransparency = 0.5, BorderSizePixel = 0,
                Text = '', AutoButtonColor = false, ClipsDescendants = true, LayoutOrder = bZ,
                Parent = bY
            }
        )
        aj(b2, UDim.new(0, 8))
        local b3 = ak(b2)
        local b4 = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 11),
                Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = z.Text,
                ScaleType = Enum.ScaleType.Fit, Parent = b2
            }
        )
        aq(b4, b_)
        am(
            {
                Position = UDim2.new(0, 4, 0, 32), Size = UDim2.new(1, -8, 0, 14), Text = b0,
                TextSize = 11, TextColor3 = z.Muted, TextXAlignment = Enum.TextXAlignment.Center,
                Parent = b2
            }
        )
        b2.MouseEnter:Connect(
            function()
                ah(b2, {BackgroundTransparency = 0}, 0.15, Enum.EasingStyle.Quint)
                ah(b3, {Color = z.StrokeHover}, 0.15)
                ah(b4, {ImageColor3 = z.Accent}, 0.15)
            end
        )
        b2.MouseLeave:Connect(
            function()
                ah(b2, {BackgroundTransparency = 0.5}, 0.25, Enum.EasingStyle.Quint)
                ah(b3, {Color = z.Stroke}, 0.25)
                ah(b4, {ImageColor3 = z.Text}, 0.25)
            end
        )
        b2.MouseButton1Click:Connect(
            function()
                aE(b2)
                aJ(b1)
            end
        )
        return b2
    end
    function a2:_homeGame(bY, bZ)
        local b_ = self:_homeCard(bY, bZ)
        local b0 = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = 1, Parent = b_}
        )
        local b1 = ai(
            'ImageLabel',
            {
                Size = UDim2.fromOffset(44, 44), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Image = 'rbxthumb://type=GameIcon&id=' .. tostring(game.GameId) .. '&w=150&h=150',
                Parent = b0
            }
        )
        aj(b1, UDim.new(0, 10))
        ak(b1)
        local b2 = am(
            {
                Position = UDim2.fromOffset(56, 3), Size = UDim2.new(1, -56, 0, 20),
                Text = 'Loading', TextSize = 15, FontFace = D.Bold, Parent = b0
            }
        )
        local b3 = am(
            {
                Position = UDim2.fromOffset(56, 24), Size = UDim2.new(1, -56, 0, 16), Text = '',
                TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted, Parent = b0
            }
        )
        local b4 = nil
        task.spawn(
            function()
                local b5 = aY()
                b2.Text = b5 and b5.Name or aZ()
                b4 = b5 and type(b5.Creator) == 'table' and b5.Creator.Name or nil
            end
        )
        local b5 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 2, Parent = b_
            }
        )
        al(b5, 0, 0, 12, 0)
        ai(
            'UIGridLayout',
            {
                CellPadding = UDim2.fromOffset(6, 6), CellSize = UDim2.new(0.25, -5, 0, 54),
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = b5
            }
        )
        self:_homeAction(
            b5, 1, 'refresh-cw', 'Rejoin',
            function()
                self:Rejoin()
            end
        )
        self:_homeAction(
            b5, 2, 'shuffle', 'Hop',
            function()
                self:ServerHop()
            end
        )
        self:_homeAction(
            b5, 3, 'users', 'Lowest',
            function()
                self:JoinLowestServer()
            end
        )
        self:_homeAction(
            b5, 4, 'copy', 'Job ID',
            function()
                self:CopyToClipboard(game.JobId, 'Job ID')
            end
        )
        am(
            {
                Size = UDim2.new(1, 0, 0, 26),
                Text = 'Job ' .. bB(game.JobId) .. '  \u{b7}  Place ' .. tostring(game.PlaceId),
                TextSize = 11, FontFace = D.Regular, TextColor3 = z.Muted,
                TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = 3, Parent = b_
            }
        )
        return function()
            local b6 = #f:GetPlayers() .. '/' .. f.MaxPlayers .. ' players'
            b3.Text = b4 and ('by ' .. b4 .. '  \u{b7}  ' .. b6) or b6
        end
    end
    function a2:_homeLink(bY, bZ, b_, b0, b1, b2, b3)
        local b4 = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1, LayoutOrder = bZ, Parent = bY}
        )
        ai(
            'Frame',
            {
                Name = 'Rule', Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke,
                BorderSizePixel = 0, Parent = b4
            }
        )
        local b5 = aB(b4, b_, z.Accent, UDim2.new(0, 0, 0.5, 0))
        b5.Size = UDim2.fromOffset(16, 16)
        local b6 = am(
            {
                Position = UDim2.fromOffset(28, 6), Size = UDim2.new(1, -68, 0, 18), Text = b0,
                TextSize = 13, Parent = b4
            }
        )
        local b7 = am(
            {
                Position = UDim2.fromOffset(28, 24), Size = UDim2.new(1, -68, 0, 15), Text = b1,
                TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted, Parent = b4
            }
        )
        local b8 = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.fromOffset(30, 30), BackgroundColor3 = z.Surface3,
                BackgroundTransparency = 0.5, BorderSizePixel = 0, Text = '',
                AutoButtonColor = false, Parent = b4
            }
        )
        aj(b8, UDim.new(0, 8))
        local b9 = ak(b8)
        local ca = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ScaleType = Enum.ScaleType.Fit, Parent = b8
            }
        )
        aq(ca, b2)
        b8.MouseEnter:Connect(
            function()
                ah(b8, {BackgroundTransparency = 0}, 0.15, Enum.EasingStyle.Quint)
                ah(b9, {Color = z.StrokeHover}, 0.15)
                ah(ca, {ImageColor3 = z.Accent}, 0.15)
            end
        )
        b8.MouseLeave:Connect(
            function()
                ah(b8, {BackgroundTransparency = 0.5}, 0.25, Enum.EasingStyle.Quint)
                ah(b9, {Color = z.Stroke}, 0.25)
                ah(ca, {ImageColor3 = z.Muted}, 0.25)
            end
        )
        b8.MouseButton1Click:Connect(
            function()
                aJ(b3)
            end
        )
        return b4, b6, b7
    end
    function a2:_homeLinks(bY, bZ, b_)
        local b0 = {}
        if bZ.Discord then
            table.insert(
                b0,
                {
                    Icon = bZ.DiscordIcon or 'message-circle',
                    Title = bZ.DiscordTitle or 'Community', Text = bZ.Discord
                }
            )
        end
        if bZ.Website then
            table.insert(
                b0,
                {Icon = bZ.WebsiteIcon or 'globe', Title = bZ.WebsiteTitle or 'Website', Text = bZ.Website}
            )
        end
        for b1, b2 in ipairs(bZ.Links or {}) do
            table.insert(b0, b2)
        end
        local b1 = bZ.Features
        if #b0 == 0 and b1 == false then
            return nil, function() end
        end
        local b2 = self:_homeCard(bY, b_)
        self:_homeCaption(b2, 'Links', 0)
        for b3, b4 in ipairs(b0) do
            local b5 = type(b4.Callback) == 'function'
            self:_homeLink(
                b2, b3, b4.Icon or 'link', b4.Title or '', b4.Text or '',
                b5 and 'arrow-up-right' or 'copy',
                function()
                    if b5 then
                        aJ(b4.Callback)
                    else
                        self:CopyToClipboard(b4.Copy or b4.Text, b4.Title)
                    end
                end
            )
        end
        local b3 = function() end
        if b1 ~= false then
            if type(b1) == 'table' then
                self._featuresTitle = b1.Title
                self._features = b1.List or (#b1 > 0 and b1 or nil)
            end
            local b4, b5, b6 = self:_homeLink(
                b2, 100, type(b1) == 'table' and b1.Icon or 'list-checks',
                type(b1) == 'table' and b1.Title or 'Feature list', '', 'chevron-right',
                function()
                    self:ShowFeatures()
                end
            )
            b3 = function()
                local b7 = type(b1) == 'table' and b1.Desc
                b6.Text = b7 or (self:_featureSummary())
            end
            task.defer(b3)
        end
        local b5 = nil
        for b6, b7 in ipairs(b2:GetChildren()) do
            if b7:IsA('Frame') and b7:FindFirstChild('Rule') and (not b5 or b7.LayoutOrder < b5.LayoutOrder) then
                b5 = b7
            end
        end
        if b5 then
            b5.Rule.Visible = false
        end
        return b2, b3
    end
    function a2:_homeExecutor(bY, bZ, b_)
        local b0 = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, LayoutOrder = b_, Parent = bY}
        )
        local b1, b2, b3 = aV(bZ)
        local b5 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0),
                Size = UDim2.fromOffset(7, 7), BackgroundColor3 = b2 and z.Success or z.Warning,
                BorderSizePixel = 0, Parent = b0
            }
        )
        aj(b5, UDim.new(1, 0))
        local b6 = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(18, 0), Size = UDim2.new(1, -170, 1, 0),
                BackgroundTransparency = 1, ClipsDescendants = true, Parent = b0
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = b6
            }
        )
        am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = b1,
                TextSize = 12, TextTruncate = Enum.TextTruncate.None, LayoutOrder = 1, Parent = b6
            }
        )
        am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = b3,
                TextSize = 12, FontFace = D.Regular, TextColor3 = b2 and z.Muted or z.Warning,
                TextTruncate = Enum.TextTruncate.None, LayoutOrder = 2, Parent = b6
            }
        )
        local b7 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -2, 0.5, 0),
                Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Parent = b0
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = b7
            }
        )
        am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                Text = E and 'Tap the pill or' or 'Hide with', TextSize = 12, FontFace = D.Regular,
                TextColor3 = z.Muted, TextTruncate = Enum.TextTruncate.None, LayoutOrder = 1,
                Parent = b7
            }
        )
        local b8 = ai(
            'Frame',
            {
                Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = z.Surface3, BorderSizePixel = 0, LayoutOrder = 2, Parent = b7
            }
        )
        aj(b8, UDim.new(0, 5))
        ak(b8)
        al(b8, 6, 6)
        self._keyChipLabel = am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                Text = aI(self.Keybind), TextSize = 11, FontFace = D.Bold,
                TextTruncate = Enum.TextTruncate.None, Parent = b8
            }
        )
    end
    a2._featureKinds = {
        Toggle = true, Slider = true, Dropdown = true, Input = true, Keybind = true,
        ColorPicker = true, Stepper = true, Button = true, ButtonRow = true, OrderList = true
    }
    function a2:_featureGroups()
        local bY, bZ = {}, {}
        for b_, b0 in ipairs(self.Tabs) do
            if b0 ~= self.Home and b0._userVisible ~= false then
                local b1 = {Name = b0.Name, Icon = b0._iconName, Items = {}}
                for b2, b3 in ipairs(b0._subTabs or {b0}) do
                    local b5 = b3._isSubTab and b3 or nil
                    local function b6(b7, b8, b9, ca)
                        if type(b7) ~= 'string' or b7 == '' then
                            return
                        end
                        local cb = {
                            Name = b7, Kind = b8._type == 'ButtonRow' and 'Button' or b8._type,
                            Path = ca, Result = {Tab = b0, Sub = b5, Target = b8, Group = b9}
                        }
                        table.insert(b1.Items, cb)
                        bZ[string.lower(b7)] = bZ[string.lower(b7)] or cb
                    end
                    local function b7(b8, b9, ca)
                        if b8._destroyed or not self._featureKinds[b8._type] or (b8._isShown and not b8:_isShown(
                        )) then
                            return
                        end
                        if b8._type == 'ButtonRow' and b8.Buttons then
                            for cb, cc in ipairs(b8.Buttons) do
                                b6(cc.Label.Text, b8, b9, ca)
                            end
                        else
                            b6(b8._searchName, b8, b9, ca)
                        end
                    end
                    if not b3._noSearch then
                        for b8, b9 in ipairs(b3._items or {}) do
                            b7(b9, nil, b5 and b5.Name or nil)
                        end
                        for b8, b9 in ipairs(b3._groupboxes or {}) do
                            if b9._userVisible ~= false and not b9._manager then
                                for ca, cb in ipairs(b9._items) do
                                    b7(
                                        cb, b9,
                                        b5 and (b5.Name .. '  \u{203a}  ' .. b9.Name) or b9.Name
                                    )
                                end
                            end
                        end
                    end
                end
                if #b1.Items > 0 then
                    table.insert(bY, b1)
                end
            end
        end
        local b_ = self._features
        if type(b_) ~= 'table' then
            return bY
        end
        local function b0(b1)
            if type(b1) ~= 'table' then
                b1 = {Name = b1}
            end
            local b2 = tostring(b1.Name or b1.Title or b1[1] or '')
            local b3 = bZ[string.lower(b2)]
            return {
                Name = b2, Desc = b1.Desc or b1.Description, Tag = b1.Tag, Icon = b1.Icon,
                Kind = b3 and b3.Kind, Path = b3 and b3.Path, Result = b3 and b3.Result,
                Callback = b1.Callback
            }
        end
        local b1, b2 = {}, nil
        for b3, b5 in ipairs(b_) do
            if type(b5) == 'table' and type(b5.Items) == 'table' then
                local b6 = {
                    Name = tostring(b5.Name or b5.Title or 'Features'), Icon = b5.Icon, Items = {}
                }
                for b7, b8 in ipairs(b5.Items) do
                    table.insert(b6.Items, b0(b8))
                end
                table.insert(b1, b6)
            else
                if not b2 then
                    b2 = {Name = self._featuresTitle or 'Features', Items = {}}
                    table.insert(b1, b2)
                end
                table.insert(b2.Items, b0(b5))
            end
        end
        return b1
    end
    function a2:_featureSummary()
        local bY = self:_featureGroups()
        local bZ = 0
        for b_, b0 in ipairs(bY) do
            bZ += #b0.Items
        end
        local b_ = bZ .. (bZ == 1 and ' feature' or ' features')
        if type(self._features) ~= 'table' and #bY > 0 then
            b_ ..= ' across ' .. #bY .. (#bY == 1 and ' tab' or ' tabs')
        end
        return b_, bY, bZ
    end
    function a2:ShowFeatures()
        if self._dialog then
            self._dialog.Close()
        end
        local bY, bZ, b_ = self:_featureSummary()
        local b0 = 16
        local b1 = E and 44 or 38
        local b2 = self.Body
        local b3 = ai(
            'TextButton',
            {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1, Text = '', AutoButtonColor = false, ZIndex = 40,
                Parent = b2
            }
        )
        local b5 = ai(
            'CanvasGroup',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 10),
                Size = UDim2.fromOffset(420, 460), BackgroundColor3 = z.Background,
                BorderSizePixel = 0, GroupTransparency = 1, Active = true, Parent = b3
            }
        )
        aj(b5, UDim.new(0, 12))
        local b6 = ak(b5, z.Stroke, 1)
        local b7 = ai('UIScale', {Scale = 0.94, Parent = b5})
        local function b8()
            local b9 = self.Scale.Scale
            local ca = b2.AbsoluteSize / b9
            b5.Size = UDim2.fromOffset(math.min(440, ca.X - 24), math.min(480, ca.Y - 24))
        end
        b8()
        local b9 = b2:GetPropertyChangedSignal('AbsoluteSize'):Connect(b8)
        local ca = aB(b5, 'list-checks', z.Accent, UDim2.new(0, b0, 0, b0 + 10))
        ca.Size = UDim2.fromOffset(18, 18)
        am(
            {
                Position = UDim2.fromOffset(b0 + 28, b0),
                Size = UDim2.new(1, -(b0 * 2 + 28 + 36), 0, 18),
                Text = self._featuresTitle or 'Features', TextSize = 15, Parent = b5
            }
        )
        am(
            {
                Position = UDim2.fromOffset(b0 + 28, b0 + 19),
                Size = UDim2.new(1, -(b0 * 2 + 28 + 36), 0, 14), Text = bY, TextSize = 12,
                FontFace = D.Regular, TextColor3 = z.Muted, Parent = b5
            }
        )
        local cb = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -(b0 - 6), 0, b0 - 6),
                Size = E and UDim2.fromOffset(40, 40) or UDim2.fromOffset(32, 32),
                BackgroundColor3 = z.Surface3, BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, Parent = b5
            }
        )
        aj(cb, UDim.new(0, 8))
        local cc = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ScaleType = Enum.ScaleType.Fit, Parent = cb
            }
        )
        aq(cc, 'x')
        if cc.Image == '' then
            cc:Destroy()
            am(
                {
                    Size = UDim2.fromScale(1, 1), Text = '\u{d7}', TextSize = 20,
                    TextColor3 = z.Muted, TextXAlignment = Enum.TextXAlignment.Center, Parent = cb
                }
            )
        end
        cb.MouseEnter:Connect(
            function()
                ah(cb, {BackgroundTransparency = 0.5}, 0.12)
            end
        )
        cb.MouseLeave:Connect(
            function()
                ah(cb, {BackgroundTransparency = 1}, 0.2)
            end
        )
        local cd = b0 + 44
        local ce = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(b0, cd),
                Size = UDim2.new(1, -b0 * 2, 0, E and 36 or 32), BackgroundColor3 = z.Surface,
                BorderSizePixel = 0, Parent = b5
            }
        )
        aj(ce, UDim.new(0, 7))
        local cf = ak(ce)
        local cg, ch = aB(ce, 'search', z.Muted, UDim2.new(0, 10, 0.5, 0))
        ch.Parent.Size = UDim2.fromOffset(14, 14)
        local ci = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1, Text = '', PlaceholderText = 'Search features',
                PlaceholderColor3 = z.Muted, TextColor3 = z.Text, TextSize = 13,
                FontFace = D.Regular, TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ClearTextOnFocus = false, Parent = ce
            }
        )
        ci.Focused:Connect(
            function()
                ah(cf, {Color = z.StrokeHover}, 0.15)
                ah(ch, {ImageColor3 = z.Accent}, 0.15)
            end
        )
        ci.FocusLost:Connect(
            function()
                ah(cf, {Color = z.Stroke}, 0.2)
                ah(ch, {ImageColor3 = z.Muted}, 0.2)
            end
        )
        cd += (E and 36 or 32) + 10
        local cj = ai(
            'ScrollingFrame',
            {
                Position = UDim2.fromOffset(b0, cd),
                Size = UDim2.new(1, -b0 * 2 + 6, 1, -(cd + b0 - 4)), BackgroundTransparency = 1,
                BorderSizePixel = 0, ScrollBarThickness = E and 4 or 3,
                ScrollBarImageColor3 = z.Accent, ScrollBarImageTransparency = 0.4,
                ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(),
                Parent = b5
            }
        )
        local ck = ai(
            'Frame',
            {
                Size = UDim2.new(1, -10, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = cj
            }
        )
        local cl = ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = ck}
        )
        cl:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(
            function()
                cj.CanvasSize = UDim2.fromOffset(0, cl.AbsoluteContentSize.Y / self.Scale.Scale + 4)
            end
        )
        local cm = am(
            {
                Size = UDim2.new(1, 0, 0, 60), Text = b_ == 0 and 'No features yet' or 'No matches',
                TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Center, LayoutOrder = 0, Visible = b_ == 0,
                Parent = ck
            }
        )
        local cn = {}
        local co = false
        local cp = nil
        function cn.Close()
            if co then
                return
            end
            co = true
            if self._dialog == cn then
                self._dialog = nil
            end
            b9:Disconnect()
            if cp then
                task.defer(cp)
            end
            if ci:IsFocused() then
                ci:ReleaseFocus()
            end
            ah(b3, {BackgroundTransparency = 1}, 0.18)
            ah(
                b5, {Position = UDim2.new(0.5, 0, 0.5, 8), GroupTransparency = 1}, 0.18,
                Enum.EasingStyle.Quint
            )
            ah(b7, {Scale = 0.96}, 0.18, Enum.EasingStyle.Quint)
            ah(b6, {Transparency = 1}, 0.12)
            task.delay(
                0.2,
                function()
                    b3:Destroy()
                end
            )
        end
        local cq = {}
        local cr = 0
        for cs, ct in ipairs(bZ) do
            cr += 1
            local cu = ai(
                'Frame',
                {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = cr, Parent = ck}
            )
            local cv = aB(cu, ct.Icon or 'layout-grid', z.Accent, UDim2.new(0, 2, 0, 18))
            cv.Size = UDim2.fromOffset(14, 14)
            am(
                {
                    Position = UDim2.fromOffset(24, 10), Size = UDim2.new(1, -70, 0, 16),
                    Text = string.upper(ct.Name), TextSize = 11, TextColor3 = z.Muted, Parent = cu
                }
            )
            local cw = am(
                {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -4, 0, 10),
                    Size = UDim2.new(0, 40, 0, 16), Text = tostring(#ct.Items), TextSize = 11,
                    TextColor3 = z.Muted, TextXAlignment = Enum.TextXAlignment.Right, Parent = cu
                }
            )
            local cx = {Header = cu, Count = cw, Rows = {}}
            for cy, cz in ipairs(ct.Items) do
                cr += 1
                local cA = cz.Desc or cz.Path
                local cB = cz.Result ~= nil or type(cz.Callback) == 'function'
                local cC = ai(
                    'TextButton',
                    {
                        Size = UDim2.new(1, 0, 0, cA and b1 + 4 or b1 - 4),
                        BackgroundColor3 = z.Surface2, BackgroundTransparency = 1,
                        BorderSizePixel = 0, Text = '', AutoButtonColor = false, LayoutOrder = cr,
                        Parent = ck
                    }
                )
                aj(cC, UDim.new(0, 8))
                local cD = aB(
                    cC, cz.Icon or self._searchIcons[cz.Kind] or 'check', z.Muted,
                    UDim2.new(0, 10, 0.5, 0)
                )
                cD.Size = UDim2.fromOffset(14, 14)
                local cE = 12 + (cB and 22 or 0)
                local cF
                if cz.Tag then
                    cF = ai(
                        'Frame',
                        {
                            AnchorPoint = Vector2.new(1, 0.5),
                            Position = UDim2.new(1, -(cB and 30 or 10), 0.5, 0),
                            Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundColor3 = z.Accent, BackgroundTransparency = 0.85,
                            BorderSizePixel = 0, Parent = cC
                        }
                    )
                    aj(cF, UDim.new(0, 5))
                    al(cF, 7, 7)
                    am(
                        {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            Text = tostring(cz.Tag), TextSize = 11, TextColor3 = z.Accent,
                            TextTruncate = Enum.TextTruncate.None, Parent = cF
                        }
                    )
                end
                local cG = am(
                    {
                        Position = UDim2.fromOffset(34, cA and 5 or 0),
                        Size = UDim2.new(1, -(34 + cE), 0, cA and 18 or b1 - 4), Text = cz.Name,
                        TextSize = 13, Parent = cC
                    }
                )
                local cH
                if cA then
                    cH = am(
                        {
                            Position = UDim2.fromOffset(34, 23),
                            Size = UDim2.new(1, -(34 + cE), 0, 14), Text = cA, TextSize = 11,
                            FontFace = D.Regular, TextColor3 = z.Muted, Parent = cC
                        }
                    )
                end
                if cF then
                    local function cI()
                        local cJ = 34 + cE + cF.AbsoluteSize.X / self.Scale.Scale + 8
                        cG.Size = UDim2.new(1, -cJ, 0, cG.Size.Y.Offset)
                        if cH then
                            cH.Size = UDim2.new(1, -cJ, 0, 14)
                        end
                    end
                    cF:GetPropertyChangedSignal('AbsoluteSize'):Connect(cI)
                    task.defer(cI)
                end
                if cB then
                    local cI = ai(
                        'ImageLabel',
                        {
                            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                            Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1,
                            ImageColor3 = z.Muted, ImageTransparency = 0.4,
                            ScaleType = Enum.ScaleType.Fit, Parent = cC
                        }
                    )
                    aq(cI, 'arrow-up-right')
                end
                local cI = ay(
                    cC,
                    function()
                        return cj
                    end
                )
                cC.MouseEnter:Connect(
                    function()
                        if not ax() then
                            ah(cC, {BackgroundTransparency = 0.3}, 0.12)
                        end
                    end
                )
                cC.MouseLeave:Connect(
                    function()
                        ah(cC, {BackgroundTransparency = 1}, 0.2)
                    end
                )
                cC.MouseButton1Click:Connect(
                    function()
                        if not cB or not cI() then
                            return
                        end
                        cn.Close()
                        if cz.Result then
                            self:_revealResult(cz.Result)
                        end
                        aJ(cz.Callback)
                    end
                )
                table.insert(
                    cx.Rows, {Frame = cC, Key = string.lower(cz.Name .. ' ' .. (cA or ''))}
                )
            end
            table.insert(cq, cx)
        end
        ci:GetPropertyChangedSignal('Text'):Connect(
            function()
                local cs = string.lower(ci.Text)
                local ct = false
                for cu, cv in ipairs(cq) do
                    local cw = 0
                    for cx, cy in ipairs(cv.Rows) do
                        local cz = cs == '' or string.find(cy.Key, cs, 1, true) ~= nil
                        cy.Frame.Visible = cz
                        if cz then
                            cw += 1
                        end
                    end
                    cv.Header.Visible = cw > 0
                    cv.Count.Text = tostring(cw)
                    ct = ct or cw > 0
                end
                cm.Visible = not ct
                cj.CanvasPosition = Vector2.zero
            end
        )
        cb.MouseButton1Click:Connect(cn.Close)
        b3.MouseButton1Click:Connect(cn.Close)
        cp = self:_listen(
            'Began',
            function(cs)
                if cs.KeyCode == Enum.KeyCode.Escape then
                    cn.Close()
                end
            end
        )
        self._dialog = cn
        ah(b3, {BackgroundTransparency = 0.45}, 0.25)
        ah(
            b5, {Position = UDim2.fromScale(0.5, 0.5), GroupTransparency = 0}, 0.3,
            Enum.EasingStyle.Quint
        )
        ah(b7, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
        return cn
    end
    function a2:_homeStats(bY, bZ, b_, b0)
        local b1 = bZ.Stats or {'Players', 'Execs', 'Session', 'FPS', 'Ping'}
        local b2 = self:_homeCard(bY, b_)
        local b3 = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 76), BackgroundTransparency = 1, LayoutOrder = 1, Parent = b2}
        )
        ai(
            'UIGridLayout',
            {
                CellPadding = UDim2.fromOffset(24, 0), CellSize = UDim2.new(0.5, -12, 0, 76),
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = b3
            }
        )
        local b5 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                LayoutOrder = 2, Parent = b2
            }
        )
        local b6 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 3, Parent = b2
            }
        )
        al(b6, 0, 0, 12, 0)
        local b7 = ai(
            'UIGridLayout',
            {
                CellPadding = UDim2.fromOffset(0, 8), CellSize = UDim2.new(0.25, 0, 0, 36),
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = b6
            }
        )
        local b8, b9 = {}, {}
        local ca, cb = 0, 0
        for cc, cd in ipairs(b1) do
            local ce = bH[cd]
            if ce and not b8[cd] then
                if cd == 'FPS' or cd == 'Ping' then
                    ca += 1
                    b8[cd], b9[cd] = self:_homeGraph(
                        b3, cc, ce[1], ce[2], cd == 'FPS' and 60 or 100
                    )
                else
                    cb += 1
                    b8[cd] = self:_homeFigure(b6, cc, ce[2])
                end
            end
        end
        b3.Visible = ca > 0
        b6.Visible = cb > 0
        b5.Visible = ca > 0 and cb > 0
        if ca == 0 then
            al(b6, 0, 0, 0, 0)
        end
        local function cc()
            local cd = b6.AbsoluteSize.X / self.Scale.Scale
            local ce = math.clamp(cb, 1, cd >= 440 and 5 or 3)
            b7.CellSize = UDim2.new(1 / ce, 0, 0, 36)
        end
        b6:GetPropertyChangedSignal('AbsoluteSize'):Connect(cc)
        task.defer(cc)
        if b8.Executor then
            b8.Executor.Text = aU()
        end
        if b8.Game then
            b8.Game.Text = 'Loading'
            task.spawn(
                function()
                    b8.Game.Text = aZ()
                end
            )
        end
        if b8.Region then
            b8.Region.Text = 'Loading'
            a0(
                function(cd)
                    b8.Region.Text = cd
                end
            )
        end
        if b8.Execs then
            local cd = bI(bZ.StatsFolder or self.ConfigFolder)
            b8.Execs.Text = cd and tostring(cd) or '\u{2014}'
        end
        if b8.Friends then
            local cd = {}
            local function ce()
                local cf = 0
                for cg, ch in ipairs(f:GetPlayers()) do
                    if ch ~= j then
                        local ci = cd[ch.UserId]
                        if ci == nil then
                            local cj, ck = pcall(
                                function()
                                    return j:IsFriendsWith(ch.UserId)
                                end
                            )
                            ci = cj and ck == true
                            cd[ch.UserId] = ci
                        end
                        if ci then
                            cf += 1
                        end
                    end
                end
                b8.Friends.Text = tostring(cf)
            end
            task.spawn(ce)
            table.insert(
                self._connections,
                f.PlayerAdded:Connect(
                    function()
                        task.spawn(ce)
                    end
                )
            )
            table.insert(
                self._connections,
                f.PlayerRemoving:Connect(
                    function()
                        task.defer(ce)
                    end
                )
            )
        end
        local cd = b8.Session or b8.Uptime
        local ce = os.clock()
        local cf = 0
        self:_listen(
            'Render',
            function()
                cf += 1
            end
        )
        local cg = bZ.StatColors ~= false
        local function ch(ci, cj)
            if cg and ci.TextColor3 ~= cj then
                ah(ci, {TextColor3 = cj}, 0.3)
            end
        end
        return function()
            if b8.FPS then
                b8.FPS.Text = tostring(cf)
                ch(b8.FPS, k._healthColor(cf, 50, 30))
                b9.FPS(cf, k._healthColor(cf, 50, 30))
            end
            cf = 0
            if b8.Ping then
                local ci, cj = pcall(
                    function()
                        return math.floor(j:GetNetworkPing() * 1000)
                    end
                )
                cj = ci and cj or 0
                b8.Ping.Text = cj .. 'ms'
                ch(b8.Ping, k._healthColor(cj, 90, 180, true))
                b9.Ping(cj, k._healthColor(cj, 90, 180, true))
            end
            if b8.Players then
                b8.Players.Text = #f:GetPlayers() .. '/' .. f.MaxPlayers
            end
            if cd then
                cd.Text = bA(os.clock() - ce)
            end
            if b8.Time then
                b8.Time.Text = os.date(bZ.TimeFormat or '%H:%M')
            end
            if b8.ServerAge then
                b8.ServerAge.Text = bA(workspace.DistributedGameTime)
            end
            if b8.Memory then
                local ci, cj = pcall(
                    function()
                        return i:GetTotalMemoryUsageMb()
                    end
                )
                b8.Memory.Text = ci and string.format('%d MB', cj) or '\u{2014}'
                ch(b8.Memory, ci and k._healthColor(cj, 1500, 3000, true) or z.Text)
            end
        end, function()
            cf = 0
        end
    end
    local function bY(bZ, b_)
        local b0 = bZ.List
        if type(b_.Content) == 'string' then
            local b1 = bG(b0, 0, 1)
            b1.AutomaticSize = Enum.AutomaticSize.Y
            al(b1, 16, 16, 14, 16)
            am(
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    Text = b_.Content, TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextWrapped = true, TextTruncate = Enum.TextTruncate.None,
                    TextYAlignment = Enum.TextYAlignment.Top, Parent = b1
                }
            )
        end
        if type(b_.Entries) == 'table' then
            for b1, b2 in ipairs(b_.Entries) do
                local b3 = bG(b0, 0, b1 + 1)
                b3.AutomaticSize = Enum.AutomaticSize.Y
                al(b3, 16, 16, 14, 16)
                ai(
                    'UIListLayout',
                    {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = b3}
                )
                local b5 = ai(
                    'Frame',
                    {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 1, Parent = b3}
                )
                am(
                    {
                        Size = UDim2.new(1, -90, 1, 0), Text = b2.Title or b2.Version or 'Update',
                        TextSize = 15, Parent = b5
                    }
                )
                if b2.Date or b2.Tag then
                    local b6 = ai(
                        'Frame',
                        {
                            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                            Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X,
                            BackgroundColor3 = z.Surface, BorderSizePixel = 0, Parent = b5
                        }
                    )
                    aj(b6, UDim.new(0, 5))
                    ak(b6)
                    al(b6, 8, 8)
                    am(
                        {
                            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                            Text = b2.Tag or b2.Date, TextSize = 11, TextColor3 = z.Muted,
                            TextTruncate = Enum.TextTruncate.None, Parent = b6
                        }
                    )
                end
                local b6 = b2.Content or b2.Body
                if type(b2.Changes) == 'table' then
                    b6 = '\u{2022} ' .. table.concat(b2.Changes, '\n\u{2022} ')
                end
                if b6 then
                    am(
                        {
                            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                            Text = b6, TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                            TextWrapped = true, TextTruncate = Enum.TextTruncate.None,
                            TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, Parent = b3
                        }
                    )
                end
            end
        end
        if type(b_.Build) == 'function' then
            aJ(b_.Build, bZ, b0)
        else
            bZ._noSearch = true
        end
    end
    function a2:_buildHome(bZ)
        self._hideName = bZ.HideName == true
        self._hideAvatar = bZ.HideAvatar == true
        self:_renderIdentity(true)
        local b_ = self:Tab(
            {
                Name = bZ.Name or 'Home', Desc = bZ.Desc, Icon = bZ.Icon or 'house',
                PageTitle = bZ.Title or 'Home'
            }
        )
        b_._order = 100
        self.Home = b_
        local b0 = bZ.Pages or bZ.Tabs
        local b1 = b_
        if type(b0) == 'table' and #b0 > 0 then
            b1 = b_:SubTab(
                {Name = bZ.OverviewName or 'Overview', Icon = bZ.TabIcon or 'layout-grid'}
            )
        end
        b1._noSearch = true
        b1._order = 100
        local b2 = b1.List
        local b3 = self:_homeProfile(b2, bZ, 1)
        local b5, b6 = self:_homeStats(b2, bZ, 2, b_)
        local b7 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 3, Parent = b2
            }
        )
        local b8 = ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10), Parent = b7}
        )
        local function b9(ca)
            local cb = ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, LayoutOrder = ca, Parent = b7
                }
            )
            ai('UIListLayout', {SortOrder = Enum.SortOrder.LayoutOrder, Parent = cb})
            return cb
        end
        local ca, cb = b9(1), b9(2)
        local cc = self:_homeGame(ca, 1)
        local cd, ce = self:_homeLinks(cb, bZ, 1)
        if not cd then
            cb:Destroy()
        end
        local function cf()
            local cg = cd ~= nil and b7.AbsoluteSize.X / self.Scale.Scale >= 540
            b8.FillDirection = cg and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
            local ch = cg and UDim2.new(0.5, -5, 0, 0) or UDim2.new(1, 0, 0, 0)
            ca.Size = ch
            if cd then
                cb.Size = ch
            end
        end
        b7:GetPropertyChangedSignal('AbsoluteSize'):Connect(cf)
        task.defer(cf)
        self:_homeExecutor(b2, bZ, 4)
        if type(b0) == 'table' then
            for cg, ch in ipairs(b0) do
                bY(b_:SubTab({Name = ch.Name or ch.Title or 'Page', Icon = ch.Icon}), ch)
            end
        end
        b3()
        b5()
        cc()
        task.spawn(
            function()
                while not self._destroyed and b_._page.Parent do
                    task.wait(1)
                    if self.Open and self.CurrentTab == b_ then
                        b5()
                        b3()
                        cc()
                        ce()
                    else
                        b6()
                    end
                end
            end
        )
        return b_
    end
    function a2:Tab(bZ, b_)
        bZ = l(bZ, {Title = 'Name', Description = 'Desc'})
        if b_ ~= nil and bZ.Icon == nil then
            bZ.Icon = b_
        end
        local b0 = setmetatable({Name = bZ.Name or 'Tab', Window = self, _order = 0}, aS)
        local b1 = ai(
            'TextButton',
            {
                Size = UDim2.new(1, 0, 0, H), BackgroundColor3 = z.Surface3,
                BackgroundTransparency = 1, Text = '', AutoButtonColor = false,
                LayoutOrder = #self.Tabs + 1, Parent = self._tabStack
            }
        )
        aj(b1, UDim.new(0, 7))
        local b2 = ak(b1, z.Stroke, 1)
        b2.Enabled = false
        b0._button = b1
        local b3 = bZ.Icon ~= nil
        if b3 then
            local b5 = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 20, 0.5, 0),
                    Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1,
                    ImageColor3 = z.Muted, ScaleType = Enum.ScaleType.Fit, Parent = b1
                }
            )
            aq(b5, bZ.Icon)
            if b5:GetAttribute('CustomIcon') then
                b5.ImageTransparency = 0.4
            end
            b0._icon = b5
        end
        b0._label = am(
            {
                Position = UDim2.fromOffset(b3 and 38 or 14, 0),
                Size = UDim2.new(1, b3 and -46 or -22, 1, 0), Text = b0.Name, TextSize = 13,
                TextColor3 = z.Muted, Parent = b1
            }
        )
        local b5 = ai(
            'Frame',
            {
                Name = b0.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Visible = false, Parent = self.Content
            }
        )
        b0._page = b5
        local b6 = 24
        if b3 then
            local b7 = aB(b5, bZ.Icon, z.Accent, UDim2.new(0, 24, 0, 32))
            b7.Size = UDim2.fromOffset(20, 20)
            b6 = 54
        end
        b0._titleX = b6
        b0._title = am(
            {
                Position = UDim2.fromOffset(b6, 20), Size = UDim2.new(1, -b6, 0, 24),
                Text = bZ.PageTitle or b0.Name, TextSize = 22, Parent = b5
            }
        )
        if bZ.Desc then
            b0._desc = am(
                {
                    Position = UDim2.fromOffset(b6, 44), Size = UDim2.new(1, -b6, 0, 16),
                    Text = bZ.Desc, TextSize = 13, FontFace = D.Regular, TextColor3 = z.Muted,
                    Parent = b5
                }
            )
        end
        local b7 = bZ.Desc and 70 or 58
        b0._headerBottom = b7
        b0._iconName = bZ.Icon
        bJ(b0, b5, b7, bZ.Icon or 'layout-grid', bZ.EmptyText or 'Nothing here yet')
        local b8 = ai('UIScale', {Parent = b1})
        local function b9()
            ah(b8, {Scale = 1}, 0.3, Enum.EasingStyle.Quint)
        end
        b1.MouseEnter:Connect(
            function()
                if self.CurrentTab ~= b0 and not ax() then
                    ah(b1, {BackgroundTransparency = 0.75}, 0.2, Enum.EasingStyle.Quint)
                    ah(b0._label, {TextColor3 = z.Text}, 0.2)
                    if b0._icon then
                        ar(b0._icon, z.Text, true, 0.2)
                    end
                end
            end
        )
        b1.MouseLeave:Connect(
            function()
                b9()
                if self.CurrentTab ~= b0 then
                    ah(b1, {BackgroundTransparency = 1}, 0.3, Enum.EasingStyle.Quint)
                    ah(b0._label, {TextColor3 = z.Muted}, 0.3)
                    if b0._icon then
                        ar(b0._icon, z.Muted, false, 0.3)
                    end
                end
            end
        )
        b1.MouseButton1Down:Connect(
            function()
                ah(b8, {Scale = 0.97}, 0.15, Enum.EasingStyle.Quint)
            end
        )
        b1.MouseButton1Up:Connect(b9)
        local ca = ay(
            b1,
            function()
                return self.TabList
            end
        )
        b1.MouseButton1Click:Connect(
            function()
                b9()
                if ca() then
                    self:SelectTab(b0)
                end
            end
        )
        b0._stroke = b2
        self:_fitTitle(b0)
        if not self._introDone then
            b1.Visible = false
        end
        table.insert(self.Tabs, b0)
        if #self.Tabs == 1 then
            task.defer(
                function()
                    if not self.CurrentTab then
                        self:SelectTab(b0)
                    end
                end
            )
        end
        return b0
    end
    a2.CreateTab = a2.Tab
    function a2:CloudConfigs(bZ)
        bZ = l(bZ, {Title = 'Name', Description = 'Desc'})
        local b_ = self
        local b0 = self:Tab(
            {Name = bZ.Name or 'Cloud', Desc = bZ.Desc, Icon = bZ.Icon or 'cloud', PageTitle = bZ.PageTitle}
        )
        b0._noSearch = true
        b0.List.Visible = false
        if b0._empty then
            b0._empty:Destroy()
            b0._empty = nil
        end
        local b1 = 116
        local b2 = E and 36 or 32
        local b3 = E and 30 or 26
        local b5 = {'Popular', 'New', 'Top', 'Installs'}
        local b6 = {
            Popular = 'Popular', New = 'Newest', Top = 'Top rated', Installs = 'Most installed'
        }
        local b7 = {'All', 'Favorites', 'Mine', 'Installed'}
        local b8 = 40
        local b9 = math.max(math.floor(tonumber(bZ.DescriptionLimit) or 300), 20)
        local ca = math.max(math.floor(tonumber(bZ.PageSize) or 20), 1)
        local cb = type(bZ.Tags) == 'table' and bZ.Tags or {}
        local cc = math.max(math.floor(tonumber(bZ.MaxTags) or 3), 0)
        local cd = tostring(bZ.StreamerName or 'Ouroboros User')
        local ce = {Tab = b0}
        local cf, cg = {}, {}
        local ch = {}
        local ci, cj, ck = false, 0, 0
        local cl = false
        local cm = {Search = '', Sort = 'Popular', Filter = 'All', Tag = nil}
        local cn, co = {}, nil
        local cp, cq, cr = {}, nil, 0
        local cs = b_:_readConfigSettings()
        local ct = type(cs.CloudFavorites) == 'table' and cs.CloudFavorites or {}
        local cu = type(cs.CloudInstalled) == 'table' and cs.CloudInstalled or {}
        if table.find(b5, cs.CloudSort) then
            cm.Sort = cs.CloudSort
        elseif table.find(b5, bZ.Sort) then
            cm.Sort = bZ.Sort
        end
        local function cv(cw, cx)
            b_:_writeConfigSettings({[cw] = cx})
        end
        local function cw(cx, cy, cz)
            b_:Notify({Title = cy, Content = cz, Type = cx and 'Success' or 'Error', Duration = 3})
        end
        local function cx()
            return b_._hideName == true
        end
        local function cy(cz)
            local cA = type(cz) == 'string' and b_:DecodeConfig(cz)
            if not cA then
                return nil
            end
            local cB = 0
            for cC in pairs(cA) do
                cB += 1
            end
            return cB
        end
        local function cz(cA)
            cA = math.max(math.floor(tonumber(cA) or 0), 0)
            if cA >= 1e6 then
                return (('%.1f'):format(cA / 1e6):gsub('%.0$', '')) .. 'm'
            elseif cA >= 1e3 then
                return (('%.1f'):format(cA / 1e3):gsub('%.0$', '')) .. 'k'
            end
            return tostring(cA)
        end
        local function cA(cB)
            cB = tonumber(cB)
            if not cB then
                return nil
            end
            local cC = os.time() - cB
            if cC < 60 then
                return 'just now'
            elseif cC < 3600 then
                return math.floor(cC / 60) .. 'm ago'
            elseif cC < 86400 then
                return math.floor(cC / 3600) .. 'h ago'
            elseif cC < 604800 then
                return math.floor(cC / 86400) .. 'd ago'
            elseif cC < 2592000 then
                return math.floor(cC / 604800) .. 'w ago'
            end
            return os.date('%d %b %Y', cB)
        end
        local function cB(cC)
            return (cC:gsub('&', '&amp;'):gsub('<', '&lt;'):gsub('>', '&gt;'):gsub('"', '&quot;'):gsub(
                "'", '&apos;'
            ))
        end
        local function cC(cD)
            local cE = string.lower(cm.Search)
            if cE == '' then
                return cB(cD)
            end
            local cF = string.lower(cD)
            local cG = bc(z.Accent)
            local cH, cI = {}, 1
            while true do
                local cJ, cK = string.find(cF, cE, cI, true)
                if not cJ then
                    break
                end
                table.insert(cH, cB(cD:sub(cI, cJ - 1)))
                table.insert(
                    cH, ('<font color="#%s"><b>%s</b></font>'):format(cG, cB(cD:sub(cJ, cK)))
                )
                cI = cK + 1
            end
            table.insert(cH, cB(cD:sub(cI)))
            return table.concat(cH)
        end
        local function cD(cE)
            if type(cE) ~= 'table' then
                return nil
            end
            local cF = cE.Id ~= nil and tostring(cE.Id) or e:GenerateGUID(false)
            local cG = cg[cF] or {Id = cF}
            for cH, cI in pairs(cE) do
                if cH ~= 'Id' then
                    cG[cH] = cI
                end
            end
            cG.Name = tostring(cG.Name or 'Untitled')
            cG.Author = tostring(cG.Author or 'Unknown')
            cG.Description = cG.Description ~= nil and tostring(cG.Description) or ''
            local cH = {}
            for cI, cJ in ipairs(type(cG.Tags) == 'table' and cG.Tags or {}) do
                table.insert(cH, tostring(cJ))
            end
            cG.Tags = cH
            cG.Installs = tonumber(cG.Installs) or 0
            cG.Likes = tonumber(cG.Likes) or 0
            cG.Updated = tonumber(cG.Updated or cG.Created)
            cG.Liked = cG.Liked == true
            if type(cG.Code) ~= 'string' or cG.Code == '' then
                cG.Code = nil
            end
            cG.Count = tonumber(cG.Count) or cy(cG.Code)
            cG.Mine = cG.Mine == true or tonumber(cG.AuthorId) == j.UserId or tonumber(cG.OwnerId) == j.UserId
            cg[cF] = cG
            return cG
        end
        local function cE(cF)
            return {
                Id = cF.Id, Name = cF.Name, Description = cF.Description, Author = cF.Author,
                AuthorId = cF.AuthorId, Tags = table.clone(cF.Tags), Installs = cF.Installs,
                Likes = cF.Likes, Liked = cF.Liked, Updated = cF.Updated, Code = cF.Code,
                Count = cF.Count, Folder = cF.Folder, Mine = cF.Mine
            }
        end
        local function cF(cG)
            local cH = cE(cG)
            cH.Code = nil
            cH.Liked = nil
            return cH
        end
        local function cG(cH)
            local cI = cu[cH.Id]
            if type(cI) ~= 'table' then
                return nil
            end
            if cH.Updated and tonumber(cI.Updated) and cH.Updated > tonumber(cI.Updated) then
                return 'Update'
            end
            return 'Installed'
        end
        local function cH(cI)
            return type(cI.Folder) == 'string' and cI.Folder ~= b_.ConfigFolder
        end
        local function cI(cJ, cK, cL, cM, cN)
            local cO = ai(
                'TextButton',
                {
                    Size = UDim2.fromOffset(cM, cM), BackgroundColor3 = z.Surface2,
                    BackgroundTransparency = cN and 1 or 0, Text = '', AutoButtonColor = false,
                    Parent = cJ
                }
            )
            aj(cO, UDim.new(0, 8))
            if not cN then
                aG(cO, ak(cO))
            end
            local cP = ai(
                'ImageLabel',
                {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(15, 15), BackgroundTransparency = 1,
                    ImageColor3 = z.Muted, ScaleType = Enum.ScaleType.Fit, Parent = cO
                }
            )
            aq(cP, cK)
            if cP.Image == '' then
                cP:Destroy()
                cP = am(
                    {
                        Size = UDim2.fromScale(1, 1), Text = cL, TextSize = 15,
                        TextColor3 = z.Muted, TextXAlignment = Enum.TextXAlignment.Center,
                        TextTruncate = Enum.TextTruncate.None, Parent = cO
                    }
                )
            end
            return cO, cP
        end
        local function cJ(cK, cL)
            ah(cK, {BackgroundColor3 = z.Accent, BackgroundTransparency = 0.12}, 0)
            ah(cL, {TextColor3 = z.AccentDark}, 0)
            cL.FontFace = D.Bold
        end
        local function cK(cL)
            for cM, cN in ipairs(cL:GetChildren()) do
                if cN:IsA('GuiObject') then
                    cN:Destroy()
                end
            end
        end
        local function cL(cM, cN, cO, cP)
            local cQ = ai(
                'TextButton',
                {
                    Size = UDim2.fromOffset(0, b3), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = z.Surface2, Text = '', AutoButtonColor = false,
                    LayoutOrder = cO, Parent = cM
                }
            )
            cQ:SetAttribute('NoDrag', true)
            aj(cQ, UDim.new(1, 0))
            local cR = ak(cQ)
            al(cQ, 12, 12)
            local cS = am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = cN,
                    TextSize = 12, TextColor3 = z.Muted, TextTruncate = Enum.TextTruncate.None,
                    Parent = cQ
                }
            )
            local cT = {Button = cQ, Label = cS}
            function cT.Set(cU, cV)
                local cW = cV and 0 or 0.15
                ah(cQ, {BackgroundColor3 = cU and z.Accent or z.Surface2}, cW)
                ah(cS, {TextColor3 = cU and z.AccentDark or z.Muted}, cW)
                ah(cR, {Transparency = cU and 1 or 0}, cW)
            end
            if cP then
                cQ.MouseButton1Click:Connect(cP)
            else
                cQ.Active = false
            end
            return cT
        end
        local function cM(cN, cO, cP)
            local cQ = am(
                {
                    Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = z.Surface3, BackgroundTransparency = 0.2, Text = cO,
                    TextSize = 11, TextColor3 = z.Muted,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = cP, Parent = cN
                }
            )
            aj(cQ, UDim.new(0, 5))
            al(cQ, 7, 7)
            return cQ
        end
        local function cN(cO, cP, cQ)
            return ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, cP),
                    Wraps = cQ == true, Parent = cO
                }
            )
        end
        local function cO(cP, cQ)
            return ai(
                'UIListLayout',
                {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, cQ), Parent = cP}
            )
        end
        local function cP(cQ, cR, cS, cT, cU, cV)
            return am(
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = cR,
                    TextSize = cS, FontFace = cV or D.Regular, TextColor3 = cT or z.Text,
                    TextWrapped = true, TextTruncate = Enum.TextTruncate.None,
                    TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = cU, Parent = cQ
                }
            )
        end
        local function cQ(cR, cS)
            local cT = ai(
                'ScrollingFrame',
                {
                    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
                    ScrollBarThickness = 3, ScrollBarImageColor3 = z.Accent,
                    ScrollBarImageTransparency = 0.4,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(),
                    Visible = cS ~= false, Parent = cR
                }
            )
            cT:SetAttribute('NoDrag', true)
            return cT
        end
        local function cR(cS, cT, cU, cV, cW)
            local cX = cV > b2
            local cY = ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, cV), BackgroundColor3 = z.Surface,
                    BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = cT, Parent = cS
                }
            )
            aj(cY, UDim.new(0, 8))
            local cZ = ak(cY)
            local c_ = ai(
                'TextBox',
                {
                    Position = UDim2.fromOffset(10, cX and 8 or 0),
                    Size = UDim2.new(1, -20, 1, cX and -24 or 0), BackgroundTransparency = 1,
                    Text = '', PlaceholderText = cU, PlaceholderColor3 = z.Muted,
                    TextColor3 = z.Text, TextSize = 13, FontFace = D.Regular,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = cX and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
                    MultiLine = cX, TextWrapped = cX, ClearTextOnFocus = false, Parent = cY
                }
            )
            local c0 = cX and am(
                {
                    AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -10, 1, -4),
                    Size = UDim2.fromOffset(0, 14), AutomaticSize = Enum.AutomaticSize.X, Text = '',
                    TextSize = 11, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextTruncate = Enum.TextTruncate.None, Parent = cY
                }
            )
            c_.Focused:Connect(
                function()
                    ah(cZ, {Color = z.StrokeHover}, 0.15)
                end
            )
            c_.FocusLost:Connect(
                function()
                    ah(cZ, {Color = z.Stroke}, 0.2)
                end
            )
            c_:GetPropertyChangedSignal('Text'):Connect(
                function()
                    local c1 = c_.Text
                    local c2 = utf8.len(c1) or #c1
                    if cW and c2 > cW then
                        local c3 = utf8.offset(c1, cW + 1)
                        c_.Text = c3 and c1:sub(1, c3 - 1) or c1:sub(1, cW)
                        return
                    end
                    if c0 then
                        c0.Text = cW and (c2 .. '/' .. cW) or ''
                    end
                end
            )
            if c0 and cW then
                c0.Text = '0/' .. cW
            end
            return c_, cZ
        end
        local function cS(cT)
            cT = bM((tostring(cT or ''):gsub('[\\/:%*%?"<>|]', '')))
            if cT == '' then
                cT = 'Cloud config'
            end
            local cU, cV = cT, 2
            while b_:ConfigExists(cU) do
                cU = ('%s (%d)'):format(cT, cV)
                cV += 1
            end
            return cU
        end
        local cT = b0._headerBottom
        local cU = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(23, cT - 1), Size = UDim2.new(1, -46, 1, -(cT + 14)),
                BackgroundTransparency = 1, ClipsDescendants = true, Parent = b0._page
            }
        )
        for cV, cW in ipairs({'Browse', 'Detail', 'Publish'}) do
            cn[cW] = ai(
                'Frame',
                {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = cU}
            )
            al(cn[cW], 1, 1, 1, 1)
        end
        local function cV(cW)
            if co == cW then
                return
            end
            local cX = co
            co = cW
            if cX then
                cX.Visible = false
            end
            local cY = cW == cn.Browse and -24 or 24
            cW.Position = UDim2.fromOffset(cY, 0)
            cW.Visible = true
            ah(cW, {Position = UDim2.fromOffset(0, 0)}, 0.3, Enum.EasingStyle.Quint)
        end
        local cW = cn.Browse
        local cX = ai(
            'Frame', {Size = UDim2.new(1, 0, 0, b2), BackgroundTransparency = 1, Parent = cW}
        )
        local cY, cZ = bF(
            cX, 'Publish',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0),
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X
            },
            function()
                ce:OpenPublish()
            end
        )
        cJ(cY, cZ)
        cY.Visible = type(bZ.OnPublish) == 'function'
        local c_, c0 = cI(cX, 'refresh-cw', 'R', b2)
        c_.AnchorPoint = Vector2.new(1, 0)
        local c1 = ai(
            'Frame',
            {
                Size = UDim2.new(1, -(b2 + 8), 1, 0), BackgroundColor3 = z.Surface2,
                BorderSizePixel = 0, Parent = cX
            }
        )
        aj(c1, UDim.new(0, 8))
        local c2 = ak(c1)
        local c3, c4 = aB(c1, 'search', z.Muted, UDim2.new(0, 10, 0.5, 0))
        c3.Size = UDim2.fromOffset(14, 14)
        local c5 = ai(
            'TextBox',
            {
                Position = UDim2.fromOffset(32, 0), Size = UDim2.new(1, -62, 1, 0),
                BackgroundTransparency = 1, Text = '',
                PlaceholderText = bZ.SearchPlaceholder or (E and 'Search configs...' or 'Search configs...   ( / )'),
                PlaceholderColor3 = z.Muted, TextColor3 = z.Text, TextSize = 13,
                FontFace = D.Regular, TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false, ClipsDescendants = true, Parent = c1
            }
        )
        local c6 = cI(c1, 'x', 'x', 24, true)
        c6.AnchorPoint = Vector2.new(1, 0.5)
        c6.Position = UDim2.new(1, -4, 0.5, 0)
        c6.Visible = false
        local c7
        local c8 = 0
        local c9 = type(cs.CloudRecent) == 'table' and cs.CloudRecent or {}
        local da = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(0, b2 + 4), Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = z.Surface2,
                BorderSizePixel = 0, Visible = false, ZIndex = 5, Parent = cW
            }
        )
        aj(da, UDim.new(0, 8))
        ak(da)
        al(da, 6, 6, 6, 6)
        cO(da, 2)
        local function db(dc)
            dc = bM(dc)
            if #dc < 2 then
                return
            end
            for dd = #c9, 1, -1 do
                if string.lower(c9[dd]) == string.lower(dc) then
                    table.remove(c9, dd)
                end
            end
            table.insert(c9, 1, dc)
            while #c9 > 6 do
                table.remove(c9)
            end
            cv('CloudRecent', c9)
        end
        local function dc(dd)
            dd = dd and #c9 > 0 and c5.Text == ''
            if dd == da.Visible then
                return
            end
            da.Visible = dd
            if not dd then
                return
            end
            cK(da)
            local de = ai(
                'Frame',
                {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 0, Parent = da}
            )
            am(
                {
                    Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -60, 1, 0),
                    Text = 'Recent searches', TextSize = 11, TextColor3 = z.Muted, Parent = de
                }
            )
            local df = ai(
                'TextButton',
                {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 0),
                    Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1, Text = 'Clear', TextSize = 11, FontFace = D.Medium,
                    TextColor3 = z.Accent, AutoButtonColor = false, Parent = de
                }
            )
            df.MouseButton1Down:Connect(
                function()
                    c9 = {}
                    cv('CloudRecent', c9)
                    dc(false)
                end
            )
            for dg, dh in ipairs(c9) do
                local di = ai(
                    'TextButton',
                    {
                        Size = UDim2.new(1, 0, 0, E and 32 or 28), BackgroundColor3 = z.Surface3,
                        BackgroundTransparency = 1, Text = '', AutoButtonColor = false,
                        LayoutOrder = dg, Parent = da
                    }
                )
                aj(di, UDim.new(0, 6))
                local dj = aB(di, 'history', z.Muted, UDim2.new(0, 8, 0.5, 0))
                dj.Size = UDim2.fromOffset(13, 13)
                am(
                    {
                        Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -34, 1, 0),
                        Text = dh, TextSize = 13, FontFace = D.Regular, Parent = di
                    }
                )
                di.MouseEnter:Connect(
                    function()
                        ah(di, {BackgroundTransparency = 0.5}, 0.1)
                    end
                )
                di.MouseLeave:Connect(
                    function()
                        ah(di, {BackgroundTransparency = 1}, 0.15)
                    end
                )
                di.MouseButton1Down:Connect(
                    function()
                        c8 += 1
                        c5.Text = dh
                        cm.Search = dh
                        db(dh)
                        dc(false)
                        c5:ReleaseFocus()
                        c7(false)
                    end
                )
            end
        end
        local function dd()
            local de = b_.Scale.Scale
            local df = cY.Visible and (cY.AbsoluteSize.X / de + 8) or 0
            c_.Position = UDim2.new(1, -df, 0, 0)
            c1.Size = UDim2.new(1, -(df + b2 + 8), 1, 0)
            da.Size = UDim2.new(1, -(df + b2 + 8), 0, 0)
        end
        cY:GetPropertyChangedSignal('AbsoluteSize'):Connect(dd)
        task.defer(dd)
        local de = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(0, b2 + 7), Size = UDim2.new(1, 0, 0, b3 + 2),
                BackgroundTransparency = 1, Parent = cW
            }
        )
        local df = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -1, 0, 1),
                Size = UDim2.fromOffset(0, b3), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = z.Surface2, Text = '', AutoButtonColor = false, Parent = de
            }
        )
        aj(df, UDim.new(1, 0))
        aG(df, ak(df))
        al(df, 10, 12)
        cN(df, 6)
        local dg = aB(df, 'arrow-down-up', z.Accent, UDim2.new())
        dg.Size = UDim2.fromOffset(13, 13)
        local dh = am(
            {
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                Text = b6[cm.Sort], TextSize = 12, TextTruncate = Enum.TextTruncate.None,
                LayoutOrder = 2, Parent = df
            }
        )
        local di = ai(
            'ScrollingFrame',
            {
                Size = UDim2.new(1, -120, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X,
                AutomaticCanvasSize = Enum.AutomaticSize.X, CanvasSize = UDim2.new(), Parent = de
            }
        )
        di:SetAttribute('NoDrag', true)
        cN(di, 6)
        al(di, 1, 1, 1, 1)
        local function dj()
            local dk = df.AbsoluteSize.X / b_.Scale.Scale
            di.Size = UDim2.new(1, -(dk + 8), 1, 0)
        end
        df:GetPropertyChangedSignal('AbsoluteSize'):Connect(dj)
        task.defer(dj)
        local dk = b2 + 8 + b3 + 10
        local dl = cQ(cW)
        dl.Position = UDim2.fromOffset(0, dk)
        dl.Size = UDim2.new(1, 0, 1, -dk)
        al(dl, 1, 6, 1, 12)
        cO(dl, 10)
        local dm = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = 0, Parent = dl}
        )
        local dn = am(
            {
                Size = UDim2.new(1, -100, 1, 0), Text = '', RichText = true, TextSize = 12,
                FontFace = D.Regular, TextColor3 = z.Muted, Parent = dm
            }
        )
        local dp = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0),
                Size = UDim2.fromOffset(0, 16), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Text = 'Clear filters', TextSize = 12,
                FontFace = D.Medium, TextColor3 = z.Accent, AutoButtonColor = false,
                Visible = false, Parent = dm
            }
        )
        local dq
        local function dr()
            return cm.Search ~= '' or cm.Tag ~= nil or cm.Filter ~= 'All'
        end
        local function ds(dt)
            local du = {}
            if cm.Filter ~= 'All' then
                table.insert(du, 'in ' .. cm.Filter)
            end
            if cm.Tag then
                table.insert(du, 'tagged ' .. cB(cm.Tag))
            end
            if cm.Search ~= '' then
                table.insert(
                    du,
                    ('matching <font color="#%s">"%s"</font>'):format(bc(z.Accent), cB(cm.Search))
                )
            end
            local dv = #du > 0 and (' ' .. table.concat(du, ', ')) or ''
            if dt or (cl and #cf == 0) then
                dn.Text = 'Searching' .. dv .. '...'
            else
                local dw = #cf
                dn.Text = ('%d%s config%s%s'):format(
                    dw, ci and '+' or '', (dw == 1 and not ci) and '' or 's', dv
                )
            end
            dp.Visible = dr()
        end
        local dt = nil
        local function du(dv)
            cl = dv
            if dv and not dt then
                c0.Rotation = 0
                dt = a:Create(
                    c0, TweenInfo.new(0.9, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
                    {Rotation = 360}
                )
                dt:Play()
            elseif not dv and dt then
                dt:Cancel()
                dt = nil
                ah(c0, {Rotation = 360}, 0.35, Enum.EasingStyle.Quint)
            end
            ds()
        end
        local dv = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 1, Parent = dl
            }
        )
        local dw = ai(
            'UIGridLayout',
            {
                CellSize = UDim2.new(1, 0, 0, b1), CellPadding = UDim2.fromOffset(8, 8),
                SortOrder = Enum.SortOrder.LayoutOrder, Parent = dv
            }
        )
        local function dx()
            local dy = dl.AbsoluteSize.X / b_.Scale.Scale
            local dz = dy >= 620 and 2 or 1
            dw.CellSize = UDim2.new(1 / dz, -(dz - 1) * 8 / dz, 0, b1)
        end
        dl:GetPropertyChangedSignal('AbsoluteSize'):Connect(dx)
        task.defer(dx)
        local dy = bF(
            dl, 'Load more', {Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 2, Visible = false},
            function()
                ce:LoadMore()
            end
        )
        local dz = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 180), BackgroundTransparency = 1, Visible = false,
                LayoutOrder = 3, Parent = dl
            }
        )
        local dA = {}
        local function dB(dC)
            for dD = 1, dC do
                local dE = ai(
                    'Frame',
                    {BackgroundColor3 = z.Surface2, BorderSizePixel = 0, LayoutOrder = 100000 + #dA, Parent = dv}
                )
                aj(dE, UDim.new(0, 10))
                ak(dE)
                for dF, dG in ipairs({{14, 0.45}, {36, 0.3}, {58, 0.8}, {76, 0.6}}) do
                    local dH = ai(
                        'Frame',
                        {
                            Position = UDim2.fromOffset(14, dG[1]),
                            Size = UDim2.new(dG[2], -14, 0, dF == 1 and 14 or 10),
                            BackgroundColor3 = z.Surface3, BorderSizePixel = 0, Parent = dE
                        }
                    )
                    aj(dH, UDim.new(0, 4))
                    a:Create(
                        dH,
                        TweenInfo.new(
                            0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true
                        ), {BackgroundTransparency = 0.65}
                    ):Play()
                end
                table.insert(dA, dE)
            end
        end
        local function dC()
            for dD, dE in ipairs(dA) do
                dE:Destroy()
            end
            dA = {}
        end
        local function dD(dE, dF)
            cK(dz)
            dz.Visible = dE ~= nil
            if not dE then
                return
            end
            local dG, dH = by(dz, dE == 'error' and 'cloud-off' or 'search-x', dF)
            dG.Size = UDim2.fromOffset(280, 70)
            dG.Position = UDim2.new(0.5, 0, 0, 60)
            dH.TextWrapped = true
            dH.TextTruncate = Enum.TextTruncate.None
            dH.Size = UDim2.new(1, 0, 0, 32)
            if dE == 'error' or dr() then
                bF(
                    dz, dE == 'error' and 'Try again' or 'Clear filters',
                    {
                        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 132),
                        Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X
                    },
                    function()
                        if dE == 'error' then
                            ce:Refresh()
                        else
                            dq()
                        end
                    end
                )
            end
            ds()
        end
        local dE, dF, dG
        local function dH(dI)
            local dJ = dI.Record
            dI.Title.Text = cC(dJ.Name)
            local dK = {'by ' .. dJ.Author}
            local dL = cA(dJ.Updated)
            if dL then
                table.insert(dK, dL)
            end
            if dJ.Count then
                table.insert(dK, dJ.Count .. (dJ.Count == 1 and ' setting' or ' settings'))
            end
            dI.Meta.Text = table.concat(dK, '  \u{b7}  ')
            dI.Desc.Text = dJ.Description ~= '' and cC(dJ.Description) or 'No description'
            dI.Desc.TextTransparency = dJ.Description ~= '' and 0.2 or 0.55
            dI.Likes.Text = cz(dJ.Likes)
            dI.Installs.Text = cz(dJ.Installs)
            ah(dI.Heart, {ImageColor3 = dJ.Liked and z.Accent or z.Muted}, 0.15)
            local dM = cG(dJ)
            local dN, dO
            if dM == 'Update' then
                dN, dO = 'UPDATE', z.Accent
            elseif dM == 'Installed' then
                dN, dO = 'INSTALLED', z.Success
            elseif dJ.Mine then
                dN, dO = 'YOURS', z.Accent
            elseif cH(dJ) then
                dN, dO = 'OTHER SCRIPT', z.Warning
            end
            dI.Badge.Visible = dN ~= nil
            if dN then
                dI.Badge.Text = dN
                ah(dI.Badge, {TextColor3 = dO, BackgroundColor3 = dO}, 0)
            end
            dI.Star.Visible = ct[dJ.Id] ~= nil
            dI.InstallText.Text = dM == 'Update' and 'Update' or (dM == 'Installed' and 'Reinstall' or 'Install')
            cK(dI.TagRow)
            for dP, dQ in ipairs(dJ.Tags) do
                if dP > 3 then
                    cM(dI.TagRow, '+' .. (#dJ.Tags - 3), dP)
                    break
                end
                cM(dI.TagRow, dQ, dP)
            end
        end
        local function dI(dJ, dK)
            local dL = ai(
                'TextButton',
                {
                    BackgroundColor3 = z.Surface2, BorderSizePixel = 0, Text = '',
                    AutoButtonColor = false, LayoutOrder = dK, Parent = dv
                }
            )
            dL:SetAttribute('NoDrag', true)
            aj(dL, UDim.new(0, 10))
            aG(dL, ak(dL))
            al(dL, 14, 14, 12, 12)
            local dM = {Record = dJ, Frame = dL}
            dM.Title = am(
                {Size = UDim2.new(1, -110, 0, 18), RichText = true, TextSize = 14, FontFace = D.Bold, Parent = dL}
            )
            local dN = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0),
                    Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1, Parent = dL
                }
            )
            local dO = cN(dN, 6)
            dO.HorizontalAlignment = Enum.HorizontalAlignment.Right
            dM.Star = am(
                {
                    Size = UDim2.fromOffset(14, 18), Text = '\u{2605}', TextSize = 13,
                    TextColor3 = z.Accent, TextXAlignment = Enum.TextXAlignment.Center,
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = 1, Parent = dN
                }
            )
            dM.Badge = am(
                {
                    Size = UDim2.fromOffset(0, 17), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 0.85, TextSize = 10, FontFace = D.Bold,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = 2, Parent = dN
                }
            )
            aj(dM.Badge, UDim.new(0, 5))
            al(dM.Badge, 6, 6)
            dM.Meta = am(
                {
                    Position = UDim2.fromOffset(0, 20), Size = UDim2.new(1, 0, 0, 16),
                    TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted, Parent = dL
                }
            )
            dM.Desc = am(
                {
                    Position = UDim2.fromOffset(0, 41), RichText = true,
                    Size = UDim2.new(1, 0, 0, 30), TextSize = 12, FontFace = D.Regular,
                    TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, Parent = dL
                }
            )
            local dP = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
                    Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = dL
                }
            )
            dM.TagRow = ai(
                'Frame',
                {Size = UDim2.new(1, -190, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = dP}
            )
            cN(dM.TagRow, 4)
            local dQ, dR = bF(
                dP, 'Install',
                {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.fromOffset(76, 26)
                },
                function()
                    dF(dJ)
                end
            )
            cJ(dQ, dR)
            dM.InstallText = dR
            local dS = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -86, 0.5, 0),
                    Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1, Parent = dP
                }
            )
            cN(dS, 4)
            local function dT(dU, dV)
                local dW, dX = aB(dS, dU, z.Muted, UDim2.new())
                dW.Size = UDim2.fromOffset(12, 12)
                dW.LayoutOrder = dV
                local dY = am(
                    {
                        Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 12, TextColor3 = z.Muted, TextTruncate = Enum.TextTruncate.None,
                        LayoutOrder = dV + 1, Parent = dS
                    }
                )
                return dY, dX
            end
            dM.Likes, dM.Heart = dT('heart', 1)
            ai(
                'Frame',
                {Size = UDim2.fromOffset(4, 1), BackgroundTransparency = 1, LayoutOrder = 3, Parent = dS}
            )
            dM.Installs = dT('download', 4)
            local dU = ay(
                dL,
                function()
                    return dl
                end
            )
            dL.MouseButton1Click:Connect(
                function()
                    if dU() then
                        if cm.Search ~= '' then
                            db(cm.Search)
                        end
                        dE(dJ)
                    end
                end
            )
            ch[dJ.Id] = dM
            dH(dM)
            return dM
        end
        local function dJ()
            for dK, dL in pairs(ch) do
                dL.Frame:Destroy()
            end
            ch = {}
            for dK, dL in ipairs(cf) do
                dI(dL, dK)
            end
        end
        local function dK()
            local dL = cm.Filter == 'Favorites' and ct or cu
            local dM = string.lower(cm.Search)
            local dN = {}
            for dO, dP in pairs(dL) do
                local dQ = cm.Filter == 'Favorites' and dP or (type(dP) == 'table' and dP.Record)
                if type(dQ) == 'table' then
                    dQ = table.clone(dQ)
                    dQ.Id = dO
                    local dR = cD(dQ)
                    local dS = dM == '' or string.find(string.lower(dR.Name), dM, 1, true) or string.find(
                        string.lower(dR.Description), dM, 1, true
                    )
                    if dS and cm.Tag then
                        dS = table.find(dR.Tags, cm.Tag) ~= nil
                    end
                    if dS then
                        table.insert(dN, dR)
                    end
                end
            end
            table.sort(
                dN,
                function(dO, dP)
                    if cm.Sort == 'New' then
                        return (dO.Updated or 0) > (dP.Updated or 0)
                    elseif cm.Sort == 'Installs' then
                        return dO.Installs > dP.Installs
                    end
                    return dO.Likes > dP.Likes
                end
            )
            return dN
        end
        local function dL()
            if cm.Filter == 'Favorites' then
                return [[No favorites yet. Open a config and press Favorite to keep it here.]]
            elseif cm.Filter == 'Installed' then
                return 'Nothing installed from the cloud yet'
            elseif cm.Filter == 'Mine' then
                return "You haven't published anything yet"
            elseif cm.Search ~= '' or cm.Tag then
                return 'No configs match your search'
            end
            return tostring(bZ.EmptyText or 'No configs shared yet. Be the first!')
        end
        function c7(dM)
            ck += 1
            local dN = ck
            if cm.Filter == 'Favorites' or cm.Filter == 'Installed' then
                du(false)
                dC()
                cf = dK()
                ci = false
                dJ()
                dy.Visible = false
                dD(#cf == 0 and 'empty' or nil, dL())
                return
            end
            if type(bZ.OnFetch) ~= 'function' then
                dJ()
                dD(#cf == 0 and 'empty' or nil, dL())
                return
            end
            if dM then
                if not ci then
                    return
                end
                cj += 1
            else
                cj = 1
                cf = {}
                dJ()
                dl.CanvasPosition = Vector2.zero
            end
            du(true)
            dC()
            dB(dM and 2 or 4)
            dy.Visible = false
            dD(nil)
            local dO = {
                Search = cm.Search, Sort = cm.Sort, Filter = cm.Filter, Tag = cm.Tag, Page = cj,
                PageSize = ca, Folder = b_.ConfigFolder, UserId = j.UserId
            }
            task.spawn(
                function()
                    local dP, dQ, dR = aK(
                        function()
                            return bZ.OnFetch(dO)
                        end
                    )
                    if dN ~= ck then
                        return
                    end
                    du(false)
                    dC()
                    if not dP or type(dQ) ~= 'table' then
                        if dM then
                            cj -= 1
                        end
                        if not dP then
                            warn('[AirFlow] cloud OnFetch error: ' .. tostring(dQ))
                        end
                        ci = dM and ci or false
                        dy.Visible = false
                        dD(
                            'error',
                            not dP and 'Could not load configs' or tostring(
                                dR or 'Could not load configs'
                            )
                        )
                        return
                    end
                    ci = dR == true
                    local dS = {}
                    for dT, dU in ipairs(cf) do
                        dS[dU] = true
                    end
                    for dT, dU in ipairs(dQ) do
                        local dV = cD(dU)
                        if dV and not dS[dV] then
                            dS[dV] = true
                            table.insert(cf, dV)
                            dI(dV, #cf)
                        end
                    end
                    dy.Visible = ci
                    dD(#cf == 0 and 'empty' or nil, dL())
                end
            )
        end
        dl:GetPropertyChangedSignal('CanvasPosition'):Connect(
            function()
                if not ci or cl then
                    return
                end
                local dM = b_.Scale.Scale
                local dN = dl.AbsoluteCanvasSize.Y / dM - dl.AbsoluteWindowSize.Y / dM - dl.CanvasPosition.Y
                if dN < 160 then
                    c7(true)
                end
            end
        )
        local dM, dN = {}, {}
        local function dO(dP)
            for dQ, dR in pairs(dM) do
                dR.Set(cm.Filter == dQ, dP)
            end
            for dQ, dR in pairs(dN) do
                dR.Set(cm.Tag == dQ, dP)
            end
            dh.Text = b6[cm.Sort]
        end
        for dP, dQ in ipairs(b7) do
            if not (dQ == 'Mine' and bZ.MineFilter == false) then
                dM[dQ] = cL(
                    di, dQ, dP,
                    function()
                        if cm.Filter ~= dQ then
                            cm.Filter = dQ
                            dO()
                            c7(false)
                        end
                    end
                )
            end
        end
        if #cb > 0 then
            ai(
                'Frame',
                {
                    Size = UDim2.fromOffset(1, 16), BackgroundColor3 = z.Stroke,
                    BorderSizePixel = 0, LayoutOrder = 10, Parent = di
                }
            )
        end
        for dP, dQ in ipairs(cb) do
            dQ = tostring(dQ)
            dN[dQ] = cL(
                di, dQ, 10 + dP,
                function()
                    cm.Tag = cm.Tag ~= dQ and dQ or nil
                    dO()
                    c7(false)
                end
            )
        end
        df.MouseButton1Click:Connect(
            function()
                local dP = table.find(b5, cm.Sort) or 1
                cm.Sort = b5[dP % #b5 + 1]
                cv('CloudSort', cm.Sort)
                dO()
                c7(false)
            end
        )
        function dq()
            c8 += 1
            c5.Text = ''
            cm.Search, cm.Tag, cm.Filter = '', nil, 'All'
            dO()
            c7(false)
        end
        dp.MouseButton1Click:Connect(dq)
        c5:GetPropertyChangedSignal('Text'):Connect(
            function()
                c6.Visible = c5.Text ~= ''
                dc(c5:IsFocused())
                c8 += 1
                local dP = c8
                local dQ = bM(c5.Text)
                if dQ ~= cm.Search then
                    ds(true)
                end
                task.delay(
                    0.35,
                    function()
                        dQ = bM(c5.Text)
                        if dP == c8 and dQ ~= cm.Search then
                            cm.Search = dQ
                            c7(false)
                        end
                    end
                )
            end
        )
        c5.Focused:Connect(
            function()
                ah(c2, {Color = z.Accent}, 0.15)
                ah(c4, {ImageColor3 = z.Accent}, 0.15)
                dc(true)
            end
        )
        c5.FocusLost:Connect(
            function(dP)
                ah(c2, {Color = z.Stroke}, 0.2)
                ah(c4, {ImageColor3 = z.Muted}, 0.2)
                db(c5.Text)
                task.delay(
                    0.15,
                    function()
                        if not c5:IsFocused() then
                            dc(false)
                        end
                    end
                )
                if dP then
                    c8 += 1
                    local dQ = bM(c5.Text)
                    if dQ ~= cm.Search then
                        cm.Search = dQ
                        c7(false)
                    end
                end
            end
        )
        c6.MouseButton1Click:Connect(
            function()
                c8 += 1
                c5.Text = ''
                if cm.Search ~= '' then
                    cm.Search = ''
                    c7(false)
                end
            end
        )
        b_:_listen(
            'Began',
            function(dP, dQ)
                if dQ or dP.KeyCode ~= Enum.KeyCode.Slash then
                    return
                end
                if b_.Open and b_.CurrentTab == b0 and co == cn.Browse and not b:GetFocusedTextBox() then
                    task.defer(
                        function()
                            c5:CaptureFocus()
                            c5.Text = c5.Text:gsub('/$', '')
                        end
                    )
                end
            end, ce
        )
        c_.MouseButton1Click:Connect(
            function()
                ce:Refresh()
            end
        )
        local function dP(dQ, dR, dS)
            if dQ.Code then
                dR(dQ.Code)
                return
            end
            local function dT(dU)
                if dS then
                    dS(dU)
                else
                    cw(false, 'Could not load config', dU)
                end
            end
            if type(bZ.OnFetchCode) ~= 'function' then
                dT('This config has no code')
                return
            end
            task.spawn(
                function()
                    local dU, dV, dW = aK(
                        function()
                            return bZ.OnFetchCode(cE(dQ))
                        end
                    )
                    if dU and type(dV) == 'string' and dV ~= '' then
                        dQ.Code = dV
                        dQ.Count = dQ.Count or cy(dV)
                        dR(dV)
                    else
                        dT(tostring(dW or (not dU and 'the request failed') or 'no code came back'))
                    end
                end
            )
        end
        function dF(dQ)
            if dQ._busy then
                return
            end
            dQ._busy = true
            dP(
                dQ,
                function(dR)
                    dQ._busy = nil
                    local dS, dT = b_:DecodeConfig(dR)
                    if not dS then
                        cw(false, 'Install failed', 'The config code is invalid')
                        return
                    end
                    local dU = 0
                    for dV in pairs(dS) do
                        dU += 1
                    end
                    local dV = cu[dQ.Id]
                    local dW = nil
                    if ba() then
                        dW = type(dV) == 'table' and type(dV.Name) == 'string' and b_:ConfigExists(
                            dV.Name
                        ) and dV.Name or cS(dQ.Name)
                    end
                    local dX = dT.Folder and dT.Folder ~= b_.ConfigFolder
                    local function dY(dZ)
                        local d_ = dZ and dW or nil
                        local d0, d1 = b_:ImportConfig(dR, d_, true)
                        if not d0 then
                            cw(false, 'Install failed', tostring(d1))
                            return
                        end
                        cu[dQ.Id] = {
                            Updated = dQ.Updated or os.time(), Name = d_, At = os.time(),
                            Record = cF(dQ)
                        }
                        cv('CloudInstalled', cu)
                        dQ.Installs += 1
                        dG(dQ)
                        cw(
                            true, 'Config installed',
                            d_ and ('Saved as ' .. d_) or 'Applied to your current settings'
                        )
                        if bZ.OnInstall then
                            task.spawn(aJ, bZ.OnInstall, cE(dQ), d_)
                        end
                    end
                    local dZ = ('%s by %s changes %d setting%s.'):format(
                        dQ.Name, dQ.Author, dU, dU == 1 and '' or 's'
                    )
                    if dX then
                        dZ ..= (' It was made for %s, so only matching settings apply.'):format(
                            dT.Folder
                        )
                    end
                    if dW then
                        dZ ..= (" Install also saves it as %s; Apply only doesn't."):format(dW)
                    end
                    local d_ = {{Title = 'Cancel'}}
                    table.insert(
                        d_,
                        {
                            Title = 'Apply only', Variant = not dW and 'Primary' or nil,
                            Callback = function()
                                dY(false)
                            end
                        }
                    )
                    if dW then
                        table.insert(
                            d_,
                            {
                                Title = 'Install', Variant = 'Primary',
                                Callback = function()
                                    dY(true)
                                end
                            }
                        )
                    end
                    b_:Dialog(
                        {
                            Title = cG(dQ) == 'Update' and 'Update config' or 'Install config',
                            Content = dZ, Icon = dX and 'triangle-alert' or 'download', Buttons = d_
                        }
                    )
                end,
                function(dR)
                    dQ._busy = nil
                    cw(false, 'Could not load config', dR)
                end
            )
        end
        local function dQ(dR)
            if type(bZ.OnLike) ~= 'function' or dR._liking then
                return
            end
            local dS = not dR.Liked
            dR.Liked = dS
            dR.Likes = math.max(dR.Likes + (dS and 1 or -1), 0)
            dR._liking = true
            dG(dR)
            task.spawn(
                function()
                    local dT, dU, dV = aK(
                        function()
                            return bZ.OnLike(cE(dR), dS)
                        end
                    )
                    dR._liking = nil
                    if not dT or dU == false then
                        dR.Liked = not dS
                        dR.Likes = math.max(dR.Likes + (dS and -1 or 1), 0)
                        dG(dR)
                        cw(false, 'Like not saved', tostring(dV or 'Try again in a moment'))
                    end
                end
            )
        end
        local function dR(dS)
            local dT = ct[dS.Id] == nil
            ct[dS.Id] = dT and cF(dS) or nil
            cv('CloudFavorites', ct)
            dG(dS)
            b_:Notify(
                {
                    Title = dT and 'Added to favorites' or 'Removed from favorites',
                    Content = dS.Name, Icon = 'star', Duration = 2
                }
            )
        end
        local function dS(dT)
            local dU = table.find(cf, dT)
            if dU then
                table.remove(cf, dU)
            end
            cg[dT.Id] = nil
            local dV = ch[dT.Id]
            if dV then
                dV.Frame:Destroy()
                ch[dT.Id] = nil
            end
            if #cf == 0 and not cl then
                dD('empty', dL())
            end
        end
        local function dT(dU)
            b_:Confirm(
                {
                    Title = 'Delete config',
                    Content = ([[Remove %s from the cloud? People who installed it keep their copy.]]):format(
                        dU.Name
                    ), Icon = 'trash-2', ConfirmText = 'Delete',
                    Callback = function()
                        task.spawn(
                            function()
                                local dV, dW, dX = aK(
                                    function()
                                        return bZ.OnDelete(cE(dU))
                                    end
                                )
                                if not dV or dW == false then
                                    cw(
                                        false, 'Delete failed',
                                        tostring(dX or 'Try again in a moment')
                                    )
                                    return
                                end
                                ct[dU.Id] = nil
                                cv('CloudFavorites', ct)
                                dS(dU)
                                cV(cn.Browse)
                                cw(true, 'Config deleted', dU.Name)
                            end
                        )
                    end
                }
            )
        end
        local function dU(dV)
            local dW = type(bZ.ReportReasons) == 'table' and bZ.ReportReasons or {
                'Broken', 'Spam', 'Inappropriate'
            }
            local dX = {{Title = 'Cancel'}}
            for dY, dZ in ipairs(dW) do
                table.insert(
                    dX,
                    {
                        Title = tostring(dZ),
                        Callback = function()
                            task.spawn(
                                function()
                                    local d_, d0 = aK(
                                        function()
                                            return bZ.OnReport(cE(dV), tostring(dZ))
                                        end
                                    )
                                    local d1 = d_ and d0 ~= false
                                    cw(
                                        d1, d1 and 'Report sent' or 'Report failed',
                                        d1 and 'Thanks for letting us know' or 'Try again in a moment'
                                    )
                                end
                            )
                        end
                    }
                )
            end
            b_:Dialog(
                {
                    Title = 'Report config', Content = ("What's wrong with %s?"):format(dV.Name),
                    Icon = 'flag', Buttons = dX
                }
            )
        end
        local dV = cQ(cn.Detail)
        al(dV, 1, 8, 1, 16)
        cO(dV, 10)
        local function dW(dX)
            local dY = type(dX) == 'table' and dX.Value or nil
            if dY == nil then
                return 'None'
            elseif type(dY) == 'boolean' then
                return dY and 'On' or 'Off'
            elseif type(dY) == 'number' then
                return (('%.2f'):format(dY):gsub('%.?0+$', ''))
            elseif type(dY) == 'table' then
                if type(dY.Hex) == 'string' then
                    return '#' .. string.upper(dY.Hex)
                elseif type(dY.Colors) == 'table' then
                    local dZ = type(dY.Name) == 'string' and dY.Name or 'Custom'
                    if type(dY.Background) == 'string' and dY.Background ~= '' then
                        dZ ..= ', image'
                    end
                    return dZ
                end
                local dZ = {}
                for d_, d0 in ipairs(dY) do
                    dZ[d_] = tostring(d0)
                end
                return #dZ > 0 and table.concat(dZ, ', ') or 'None'
            end
            return tostring(dY)
        end
        local function dX(dY)
            local dZ, d_ = pcall(e.JSONEncode, e, type(dY) == 'table' and dY.Value or nil)
            return dZ and d_ or tostring(dY)
        end
        local function dY()
            local dZ = cq
            if not dZ or not cp.Meta then
                return
            end
            cp.Title.Text = dZ.Name
            local d_ = {'by ' .. dZ.Author}
            local d0 = cA(dZ.Updated)
            if d0 then
                table.insert(d_, 'updated ' .. d0)
            end
            if cH(dZ) then
                table.insert(d_, 'made for ' .. dZ.Folder)
            end
            cp.Meta.Text = table.concat(d_, '  \u{b7}  ')
            cp.Stats.Text = ('%s like%s  \u{b7}  %s install%s'):format(
                cz(dZ.Likes), dZ.Likes == 1 and '' or 's', cz(dZ.Installs),
                dZ.Installs == 1 and '' or 's'
            )
            if cp.BuiltFor ~= dZ or cp.BuiltMine ~= dZ.Mine then
                cp.BuiltFor, cp.BuiltMine = dZ, dZ.Mine
                local d1 = cp.Actions
                cK(d1)
                local d2 = 0
                local function d3(d4, d5, d6)
                    d2 += 1
                    local d7, d8 = bF(
                        d1, d4,
                        {Size = UDim2.new(0, 0, 0, 30), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = d2},
                        d6
                    )
                    d8.TextSize = 13
                    if d5 == 'Primary' then
                        cJ(d7, d8)
                    elseif d5 == 'Danger' then
                        ah(d8, {TextColor3 = z.Error}, 0)
                    end
                    return d8
                end
                cp.InstallLabel = d3(
                    'Install', 'Primary',
                    function()
                        dF(dZ)
                    end
                )
                if type(bZ.OnLike) == 'function' then
                    cp.LikeLabel = d3(
                        'Like', nil,
                        function()
                            dQ(dZ)
                        end
                    )
                end
                cp.FavoriteLabel = d3(
                    'Favorite', nil,
                    function()
                        dR(dZ)
                    end
                )
                d3(
                    'Copy code', nil,
                    function()
                        dP(
                            dZ,
                            function(d4)
                                b_:CopyToClipboard(d4, 'Config code')
                            end
                        )
                    end
                )
                if dZ.Mine then
                    if type(bZ.OnUpdate) == 'function' then
                        d3(
                            'Edit', nil,
                            function()
                                ce:OpenPublish(dZ)
                            end
                        )
                    end
                    if type(bZ.OnDelete) == 'function' then
                        d3(
                            'Delete', 'Danger',
                            function()
                                dT(dZ)
                            end
                        )
                    end
                elseif type(bZ.OnReport) == 'function' then
                    d3(
                        'Report', 'Danger',
                        function()
                            dU(dZ)
                        end
                    )
                end
            end
            local d1 = cG(dZ)
            cp.InstallLabel.Text = d1 == 'Update' and 'Update' or (d1 == 'Installed' and 'Reinstall' or 'Install')
            if cp.LikeLabel then
                cp.LikeLabel.Text = (dZ.Liked and 'Liked' or 'Like') .. '  \u{b7}  ' .. cz(dZ.Likes)
            end
            cp.FavoriteLabel.Text = ct[dZ.Id] and 'Favorited' or 'Favorite'
        end
        local function dZ(d_, d0)
            local function d1(d2)
                if cr == d0 then
                    cp.Summary.Text = d2
                end
            end
            dP(
                d_,
                function(d2)
                    if cr ~= d0 then
                        return
                    end
                    local d3 = b_:DecodeConfig(d2)
                    if not d3 then
                        d1('The config code is invalid')
                        return
                    end
                    local d4 = bh(b_)
                    local d5 = {}
                    local d6 = 0
                    for d7, d8 in pairs(d3) do
                        local d9 = k.Flags[d7]
                        local ea = d9 ~= nil
                        local eb = ea and dX(d8) ~= dX(d4[d7])
                        if eb then
                            d6 += 1
                        end
                        table.insert(
                            d5,
                            {
                                Name = d9 and d9._searchName ~= '' and d9._searchName or d7,
                                Value = dW(d8), Known = ea, Changed = eb,
                                Rank = eb and 0 or (ea and 1 or 2)
                            }
                        )
                    end
                    table.sort(
                        d5,
                        function(d7, d8)
                            if d7.Rank ~= d8.Rank then
                                return d7.Rank < d8.Rank
                            end
                            return string.lower(d7.Name) < string.lower(d8.Name)
                        end
                    )
                    d_.Count = #d5
                    cp.Summary.Text = d6 == 0 and ('%d settings, all the same as yours'):format(#d5) or ('%d settings, %d different from yours'):format(
                        #d5, d6
                    )
                    cK(cp.Rows)
                    for d7, d8 in ipairs(d5) do
                        if d7 > 150 then
                            cP(cp.Rows, ('and %d more'):format(#d5 - 150), 12, z.Muted, d7)
                            break
                        end
                        local d9 = ai(
                            'Frame',
                            {
                                Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = z.Surface2,
                                BackgroundTransparency = d8.Changed and 0 or 0.5,
                                BorderSizePixel = 0, LayoutOrder = d7, Parent = cp.Rows
                            }
                        )
                        aj(d9, UDim.new(0, 7))
                        if d8.Changed then
                            local ea = ai(
                                'Frame',
                                {
                                    AnchorPoint = Vector2.new(0, 0.5),
                                    Position = UDim2.new(0, 10, 0.5, 0),
                                    Size = UDim2.fromOffset(6, 6), BackgroundColor3 = z.Accent,
                                    BorderSizePixel = 0, Parent = d9
                                }
                            )
                            aj(ea, UDim.new(1, 0))
                        end
                        am(
                            {
                                Position = UDim2.fromOffset(24, 0),
                                Size = UDim2.new(0.55, -24, 1, 0),
                                Text = d8.Known and d8.Name or (d8.Name .. '  (not in this script)'),
                                TextSize = 12, TextColor3 = d8.Known and z.Text or z.Muted,
                                Parent = d9
                            }
                        )
                        am(
                            {
                                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0),
                                Size = UDim2.new(0.45, -10, 1, 0), Text = d8.Value, TextSize = 12,
                                FontFace = D.Regular,
                                TextColor3 = d8.Changed and z.Accent or z.Muted,
                                TextXAlignment = Enum.TextXAlignment.Right, Parent = d9
                            }
                        )
                    end
                    if ch[d_.Id] then
                        dH(ch[d_.Id])
                    end
                end, d1
            )
        end
        function dE(d_)
            cq = d_
            cr += 1
            local d0 = cr
            cK(dV)
            cp = {}
            dV.CanvasPosition = Vector2.zero
            bF(
                dV, 'Back',
                {Size = UDim2.new(0, 0, 0, 28), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1},
                function()
                    cV(cn.Browse)
                end
            )
            cp.Title = cP(dV, d_.Name, 20, z.Text, 2, D.Bold)
            cp.Meta = cP(dV, '', 12, z.Muted, 3)
            if d_.Description ~= '' then
                cP(dV, d_.Description, 13, z.Text, 4)
            end
            if #d_.Tags > 0 then
                local d1 = ai(
                    'Frame',
                    {
                        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1, LayoutOrder = 5, Parent = dV
                    }
                )
                cN(d1, 4, true)
                for d2, d3 in ipairs(d_.Tags) do
                    cM(d1, d3, d2)
                end
            end
            cp.Stats = cP(dV, '', 12, z.Muted, 6)
            cp.Actions = ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, LayoutOrder = 7, Parent = dV
                }
            )
            cN(cp.Actions, 6, true)
            ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = z.Stroke, BorderSizePixel = 0,
                    LayoutOrder = 8, Parent = dV
                }
            )
            cP(dV, 'Settings', 14, z.Text, 9, D.Bold)
            cp.Summary = cP(dV, 'Loading settings...', 12, z.Muted, 10)
            cp.Rows = ai(
                'Frame',
                {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1, LayoutOrder = 11, Parent = dV
                }
            )
            cO(cp.Rows, 4)
            dY()
            cV(cn.Detail)
            dZ(d_, d0)
        end
        function dG(d_)
            local d0 = ch[d_.Id]
            if d0 then
                dH(d0)
            end
            if cq == d_ and co == cn.Detail then
                dY()
            end
        end
        local d_ = {Mode = 'Publish', Record = nil, Source = false, Tags = {}, Busy = false}
        local d0 = cQ(cn.Publish)
        al(d0, 1, 8, 1, 16)
        cO(d0, 8)
        bF(
            d0, 'Back',
            {Size = UDim2.new(0, 0, 0, 28), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1},
            function()
                cV(d_.Mode == 'Edit' and d_.Record and cn.Detail or cn.Browse)
            end
        )
        local d1 = cP(d0, 'Publish a config', 20, z.Text, 2, D.Bold)
        cP(d0, 'Name', 12, z.Muted, 3)
        local d2 = cR(d0, 4, 'What is it for?', b2, b8)
        cP(d0, 'Description', 12, z.Muted, 5)
        local d3 = cR(d0, 6, 'What does it do, and how should people use it?', 90, b9)
        local d4 = cP(d0, 'Tags', 12, z.Muted, 7)
        local d5 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 8, Parent = d0
            }
        )
        cN(d5, 6, true)
        d4.Visible = #cb > 0 and cc > 0
        d5.Visible = d4.Visible
        cP(d0, 'Settings to share', 12, z.Muted, 9)
        local d6 = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 10, Parent = d0
            }
        )
        cN(d6, 6, true)
        local d7 = cP(d0, '', 12, z.Muted, 11)
        local d8 = cP(d0, '', 12, z.Muted, 12)
        local d9 = cP(d0, '', 12, z.Error, 13)
        d9.Visible = false
        local ea = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 14, Parent = d0}
        )
        cN(ea, 6)
        local eb, ec = bF(
            ea, 'Publish',
            {Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1},
            function()
                ce:_submit()
            end
        )
        cJ(eb, ec)
        bF(
            ea, 'Cancel',
            {Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2},
            function()
                cV(d_.Mode == 'Edit' and d_.Record and cn.Detail or cn.Browse)
            end
        )
        local ed = {}
        local function ee()
            for ef, eg in pairs(ed) do
                eg.Set(table.find(d_.Tags, ef) ~= nil)
            end
            d4.Text = cc > 0 and ('Tags  (%d/%d)'):format(#d_.Tags, cc) or 'Tags'
        end
        for ef, eg in ipairs(cb) do
            eg = tostring(eg)
            ed[eg] = cL(
                d5, eg, ef,
                function()
                    local eh = table.find(d_.Tags, eg)
                    if eh then
                        table.remove(d_.Tags, eh)
                    elseif #d_.Tags < cc then
                        table.insert(d_.Tags, eg)
                    else
                        cw(false, 'Too many tags', ('Pick up to %d'):format(cc))
                    end
                    ee()
                end
            )
        end
        local function ef(eg)
            if d_.Source == 'Keep' then
                return nil, d_.Record and d_.Record.Count
            elseif d_.Source then
                local eh, ei = b_:ExportConfig(d_.Source)
                if not eh then
                    return nil, nil, ei
                end
                return eh, cy(eh)
            end
            local eh, ei = pcall(bj, b_, eg ~= '' and eg or 'Cloud config', bh(b_))
            if not eh then
                return nil, nil, 'could not encode your settings'
            end
            return ei, cy(ei)
        end
        local eg = {}
        local function eh()
            for ei, ej in pairs(eg) do
                ej.Set(ei == (d_.Source or '*current'))
            end
            local ei, ej, ek = ef(bM(d2.Text))
            if ek then
                d7.Text = tostring(ek)
            elseif d_.Source == 'Keep' then
                d7.Text = 'Keeps the settings already published' .. (ej and (' (' .. ej .. ')') or '')
            else
                d7.Text = ('%d setting%s from %s'):format(
                    ej or 0, ej == 1 and '' or 's', d_.Source or 'your current settings'
                )
            end
        end
        local function ei()
            cK(d6)
            eg = {}
            local ej = 0
            local function ek(el, em)
                ej += 1
                eg[el] = cL(
                    d6, em, ej,
                    function()
                        d_.Source = el ~= '*current' and el or false
                        eh()
                    end
                )
            end
            if d_.Mode == 'Edit' then
                ek('Keep', 'Keep published settings')
            end
            ek('*current', 'Current settings')
            for el, em in ipairs(b_:ListConfigs()) do
                ek(em, em)
            end
            eh()
        end
        local function ej(ek)
            d9.Text = tostring(ek)
            d9.Visible = true
        end
        function ce:OpenPublish(ek)
            local el = type(ek) == 'table' and ek.Id and cg[ek.Id] or nil
            if el then
                d_.Mode, d_.Record = 'Edit', el
                d_.Source = 'Keep'
                d_.Tags = table.clone(el.Tags)
                d2.Text = el.Name
                d3.Text = el.Description
            elseif d_.Mode == 'Edit' then
                d_.Mode, d_.Record, d_.Source, d_.Tags = 'Publish', nil, false, {}
                d2.Text = ''
                d3.Text = ''
            end
            d1.Text = el and 'Edit config' or 'Publish a config'
            ec.Text = el and 'Save changes' or 'Publish'
            d9.Visible = false
            local em = cx()
            d8.Text = em and ('Your name is hidden, so you publish as ' .. cd) or ('You publish as ' .. j.DisplayName)
            ee()
            ei()
            d0.CanvasPosition = Vector2.zero
            cV(cn.Publish)
        end
        d2:GetPropertyChangedSignal('Text'):Connect(
            function()
                d9.Visible = false
            end
        )
        function ce:_submit()
            if d_.Busy then
                return
            end
            local ek = bM(d2.Text)
            if ek == '' then
                ej('Give your config a name')
                return
            end
            local el, em, en = ef(ek)
            if en then
                ej(en)
                return
            end
            if d_.Source ~= 'Keep' and (em or 0) == 0 then
                ej('There are no settings to share')
                return
            end
            local eo = d_.Mode == 'Edit' and d_.Record or nil
            local ep = eo and bZ.OnUpdate or bZ.OnPublish
            if type(ep) ~= 'function' then
                ej(eo and "Editing isn't available" or "Publishing isn't available")
                return
            end
            local eq = cx()
            local er = {
                Name = ek, Description = bM(d3.Text), Tags = table.clone(d_.Tags), Code = el,
                Count = em, Folder = b_.ConfigFolder, Author = eq and cd or j.DisplayName,
                AuthorId = not eq and j.UserId or nil, OwnerId = j.UserId, Streamer = eq
            }
            d_.Busy = true
            ec.Text = eo and 'Saving...' or 'Publishing...'
            d9.Visible = false
            task.spawn(
                function()
                    local es, et, eu = aK(
                        function()
                            if eo then
                                return ep(cE(eo), er)
                            end
                            return ep(er)
                        end
                    )
                    d_.Busy = false
                    ec.Text = eo and 'Save changes' or 'Publish'
                    if not es or et == false then
                        if not es then
                            warn('[AirFlow] cloud publish error: ' .. tostring(et))
                        end
                        ej(es and eu and tostring(eu) or 'Something went wrong, try again')
                        return
                    end
                    local ev = table.clone(er)
                    ev.Code = el or (eo and eo.Code)
                    ev.Updated = os.time()
                    if type(et) == 'table' then
                        for ew, ex in pairs(et) do
                            ev[ew] = ex
                        end
                    end
                    if eo then
                        ev.Id = eo.Id
                        cD(ev)
                        if ct[eo.Id] then
                            ct[eo.Id] = cF(eo)
                            cv('CloudFavorites', ct)
                        end
                        dG(eo)
                        cw(true, 'Config updated', ek)
                        dE(eo)
                    else
                        d2.Text = ''
                        d3.Text = ''
                        d_.Tags = {}
                        d_.Source = false
                        if type(et) == 'table' then
                            ev.Mine = true
                            local ew = cD(ev)
                            if cm.Filter == 'All' or cm.Filter == 'Mine' then
                                table.insert(cf, 1, ew)
                                dJ()
                                dD(nil)
                            end
                            cw(true, 'Config published', ek)
                            dE(ew)
                        else
                            cw(true, 'Config published', ek)
                            cV(cn.Browse)
                            c7(false)
                        end
                    end
                end
            )
        end
        function ce:Refresh()
            c7(false)
        end
        function ce:LoadMore()
            if not cl then
                c7(true)
            end
        end
        function ce:SetConfigs(ek, el)
            ck += 1
            du(false)
            dC()
            cf = {}
            for em, en in ipairs(type(ek) == 'table' and ek or {}) do
                local eo = cD(en)
                if eo then
                    table.insert(cf, eo)
                end
            end
            ci = el == true
            dJ()
            dy.Visible = ci
            dD(#cf == 0 and 'empty' or nil, dL())
        end
        function ce:AddConfigs(ek, el)
            ck += 1
            du(false)
            dC()
            for em, en in ipairs(type(ek) == 'table' and ek or {}) do
                local eo = cD(en)
                if eo and not table.find(cf, eo) then
                    table.insert(cf, eo)
                    dI(eo, #cf)
                end
            end
            ci = el == true
            dy.Visible = ci
            dD(#cf == 0 and 'empty' or nil, dL())
        end
        function ce:UpdateConfig(ek, el)
            local em = cg[tostring(ek)]
            if em and type(el) == 'table' then
                local en = table.clone(el)
                en.Id = em.Id
                cD(en)
                dG(em)
            end
        end
        function ce:RemoveConfig(ek)
            local el = cg[tostring(ek)]
            if el then
                dS(el)
                if cq == el and co == cn.Detail then
                    cV(cn.Browse)
                end
            end
        end
        function ce:SetLoading(ek)
            ck += 1
            du(ek == true)
            dC()
            if cl then
                dB(4)
                dD(nil)
            end
        end
        function ce:SetError(ek)
            ck += 1
            du(false)
            dC()
            dD(ek and 'error' or nil, tostring(ek or ''))
        end
        function ce:Open(ek)
            local el = cg[tostring(ek)]
            if el then
                b_:SelectTab(b0)
                dE(el)
            end
        end
        function ce:Back()
            cV(cn.Browse)
        end
        function ce:GetQuery()
            return table.clone(cm)
        end
        function ce:GetFavorites()
            local ek = {}
            for el, em in pairs(ct) do
                local en = table.clone(em)
                en.Id = el
                table.insert(ek, en)
            end
            return ek
        end
        function ce:GetInstalled()
            local ek = {}
            for el, em in pairs(cu) do
                table.insert(
                    ek, {Id = el, Name = em.Name, Updated = em.Updated, Record = em.Record}
                )
            end
            return ek
        end
        dO(true)
        cV(cn.Browse)
        local ek = false
        local function el()
            if not ek and b0._page.Visible then
                ek = true
                c7(false)
            end
        end
        b0._page:GetPropertyChangedSignal('Visible'):Connect(el)
        if type(bZ.OnFetch) ~= 'function' then
            ek = true
            dD('empty', dL())
        else
            task.defer(el)
        end
        return ce
    end
    a2.CreateCloudConfigs = a2.CloudConfigs
    a2.CloudConfig = a2.CloudConfigs
    a2.CreateCloudConfig = a2.CloudConfigs
    function aS:SetBadge() end
    function aS:GetBadge()
        return nil
    end
    function a2:Dialog(bZ)
        bZ = l(bZ, {Text = 'Content', Message = 'Content'})
        if self._dialog then
            self._dialog.Close()
        end
        local b_ = 300
        local b0 = 18
        local b1 = ai(
            'TextButton',
            {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1, Text = '', AutoButtonColor = false, ZIndex = 40,
                Parent = self.Body
            }
        )
        local b2 = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 10),
                Size = UDim2.fromOffset(b_, 120), BackgroundColor3 = z.Background,
                BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 41, Parent = b1
            }
        )
        aj(b2, UDim.new(0, 10))
        local b3 = ak(b2, z.Stroke, 1)
        local b5 = ai('UIScale', {Scale = 0.94, Parent = b2})
        local b6 = {}
        local b7 = 0
        if bZ.Icon then
            local b8, b9 = aB(b2, bZ.Icon, z.Accent, UDim2.new(0, b0, 0, b0 + 9))
            b9.ImageTransparency = 1
            b8.ZIndex = 42
            b9.ZIndex = 42
            table.insert(b6, {b9, 'ImageTransparency', 0})
            b7 = 24
        end
        local b8 = am(
            {
                Position = UDim2.fromOffset(b0 + b7, b0),
                Size = UDim2.new(1, -(b0 * 2 + b7), 0, 18), Text = bZ.Title or 'Are you sure?',
                TextSize = 15, TextTransparency = 1, ZIndex = 42, Parent = b2
            }
        )
        table.insert(b6, {b8, 'TextTransparency', 0})
        local b9 = 0
        if bZ.Content then
            local ca = am(
                {
                    Position = UDim2.fromOffset(b0, b0 + 24), Size = UDim2.new(1, -b0 * 2, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y, Text = bZ.Content, TextSize = 13,
                    FontFace = D.Regular, TextColor3 = z.Muted, TextWrapped = true,
                    TextTransparency = 1, TextTruncate = Enum.TextTruncate.None,
                    TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 42, Parent = b2
                }
            )
            table.insert(b6, {ca, 'TextTransparency', 0})
            b9 = math.max(ca.TextBounds.Y, 16) + 6
            ca:GetPropertyChangedSignal('TextBounds'):Connect(
                function()
                    local cb = math.max(ca.TextBounds.Y, 16) + 6
                    if cb ~= b9 then
                        b9 = cb
                        b2.Size = UDim2.fromOffset(b_, b0 + 24 + b9 + 12 + 34 + b0)
                        local cc = b2:FindFirstChild('ButtonRow')
                        if cc then
                            cc.Position = UDim2.fromOffset(b0, b0 + 24 + b9 + 12)
                        end
                    end
                end
            )
        end
        local ca = ai(
            'Frame',
            {
                Name = 'ButtonRow', Position = UDim2.fromOffset(b0, b0 + 24 + b9 + 12),
                Size = UDim2.new(1, -b0 * 2, 0, 34), BackgroundTransparency = 1, ZIndex = 42,
                Parent = b2
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = ca
            }
        )
        b2.Size = UDim2.fromOffset(b_, b0 + 24 + b9 + 12 + 34 + b0)
        local cb = {}
        local cc = false
        function cb.Close()
            if cc then
                return
            end
            cc = true
            if self._dialog == cb then
                self._dialog = nil
            end
            ah(b1, {BackgroundTransparency = 1}, 0.18)
            ah(
                b2, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 8)}, 0.18,
                Enum.EasingStyle.Quint
            )
            ah(b5, {Scale = 0.96}, 0.18, Enum.EasingStyle.Quint)
            ah(b3, {Transparency = 1}, 0.12)
            for cd, ce in ipairs(b6) do
                ah(ce[1], {[ce[2]] = 1}, 0.12)
            end
            task.delay(
                0.2,
                function()
                    b1:Destroy()
                end
            )
        end
        for cd, ce in ipairs(bZ.Buttons or {}) do
            local cf = ce.Variant == 'Primary'
            local cg = ai(
                'TextButton',
                {
                    Size = UDim2.fromOffset(0, 34), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = cf and z.Accent or z.Surface2, BackgroundTransparency = 1,
                    BorderSizePixel = 0, Text = '', AutoButtonColor = false,
                    ClipsDescendants = true, LayoutOrder = cd, ZIndex = 43, Parent = ca
                }
            )
            aj(cg, UDim.new(0, 7))
            local ch = ak(cg, cf and z.Accent or z.Stroke, 1)
            al(cg, 14, 14)
            local ci = am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                    Text = ce.Title or ce.Name or 'OK', TextSize = 13,
                    TextColor3 = cf and z.AccentDark or z.Text,
                    TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 1, ZIndex = 44,
                    Parent = cg
                }
            )
            local cj = cf and 0.12 or 0
            local ck = cf and 0.4 or 0
            table.insert(b6, {cg, 'BackgroundTransparency', cj})
            table.insert(b6, {ch, 'Transparency', ck})
            table.insert(b6, {ci, 'TextTransparency', 0})
            cg.MouseEnter:Connect(
                function()
                    if cc then
                        return
                    end
                    if cf then
                        ah(cg, {BackgroundTransparency = 0}, 0.12)
                        ah(ch, {Transparency = 0}, 0.12)
                    else
                        ah(ch, {Color = z.StrokeHover}, 0.12)
                    end
                end
            )
            cg.MouseLeave:Connect(
                function()
                    if cc then
                        return
                    end
                    if cf then
                        ah(cg, {BackgroundTransparency = cj}, 0.2)
                        ah(ch, {Transparency = ck}, 0.2)
                    else
                        ah(ch, {Color = z.Stroke}, 0.2)
                    end
                end
            )
            cg.MouseButton1Click:Connect(
                function()
                    cb.Close()
                    aJ(ce.Callback)
                end
            )
        end
        if bZ.CloseOnBackdrop ~= false then
            b1.MouseButton1Click:Connect(
                function()
                    cb.Close()
                    aJ(bZ.OnCancel)
                end
            )
        end
        self._dialog = cb
        ah(b1, {BackgroundTransparency = 0.45}, 0.25)
        ah(
            b2, {BackgroundTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)}, 0.3,
            Enum.EasingStyle.Quint
        )
        ah(b3, {Transparency = 0}, 0.25)
        ah(b5, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
        for cd, ce in ipairs(b6) do
            ah(ce[1], {[ce[2]] = ce[3]}, 0.25)
        end
        return cb
    end
    function a2:Confirm(bZ)
        bZ = l(bZ, {Text = 'Content', Message = 'Content'})
        return self:Dialog(
            {
                Title = bZ.Title or 'Are you sure?', Content = bZ.Content, Icon = bZ.Icon,
                OnCancel = bZ.OnCancel,
                Buttons = {
                    {Title = bZ.CancelText or 'Cancel', Callback = bZ.OnCancel},
                    {Title = bZ.ConfirmText or 'Confirm', Variant = 'Primary', Callback = bZ.Callback}
                }
            }
        )
    end
    function a2:_listen(bZ, b_, b0)
        local b1 = self._inputListeners[bZ]
        table.insert(b1, b_)
        local function b2()
            for b3, b5 in ipairs(b1) do
                if b5 == b_ then
                    table.remove(b1, b3)
                    break
                end
            end
        end
        if b0 then
            b0._listeners = b0._listeners or {}
            table.insert(b0._listeners, b2)
        end
        return b2
    end
    function a2:_indicatorY(bZ)
        local b_ = self._tabStack
        return (bZ._button.AbsolutePosition.Y - b_.AbsolutePosition.Y) / self.Scale.Scale + b_.Position.Y.Offset
    end
    function a2:_placeIndicator(bZ)
        local b_ = self.Indicator
        local b0 = self:_indicatorY(bZ)
        if not b_.Visible then
            b_.Visible = true
            b_.Position = UDim2.fromOffset(8, b0)
            b_.BackgroundTransparency = 1
            ah(b_, {BackgroundTransparency = 0.35}, 0.3)
        end
        ah(b_, {Position = UDim2.fromOffset(8, b0)}, 0.45, Enum.EasingStyle.Quint)
    end
    function a2:_overflowHint(bZ, b_, b0, b1, b2)
        local b3 = ai(
            'Frame',
            {
                AnchorPoint = b_.AnchorPoint, Position = b_.Position, Size = b_.Size,
                BackgroundTransparency = 1, ZIndex = 3, Parent = bZ
            }
        )
        local function b5()
            b3.Position = b_.Position
            b3.Size = b_.Size
            b3.Visible = b_.Visible
        end
        for b6, b7 in ipairs({'Position', 'Size', 'Visible'}) do
            b_:GetPropertyChangedSignal(b7):Connect(b5)
        end
        local function b6(b7)
            return b1 and b7.Y or b7.X
        end
        local function b7()
            return self.Scale and self.Scale.Scale or 1
        end
        local function b8(b9)
            local ca = b6(b_.AbsoluteWindowSize) / b7()
            local cb = math.max(b6(b_.AbsoluteCanvasSize) / b7() - ca, 0)
            local cc = math.clamp(b6(b_.CanvasPosition) + b9 * ca * 0.75, 0, cb)
            ah(
                b_, {CanvasPosition = b1 and Vector2.new(0, cc) or Vector2.new(cc, 0)}, 0.35,
                Enum.EasingStyle.Quint
            )
        end
        local b9 = {}
        for ca, cb in ipairs({-1, 1}) do
            local cc = cb > 0
            local cd = ai(
                'Frame',
                {
                    AnchorPoint = b1 and Vector2.new(0, cc and 1 or 0) or Vector2.new(
                        cc and 1 or 0, 0
                    ),
                    Position = b1 and UDim2.fromScale(0, cc and 1 or 0) or UDim2.fromScale(
                        cc and 1 or 0, 0
                    ), Size = b1 and UDim2.new(1, 0, 0, 34) or UDim2.new(0, 48, 1, 0),
                    BackgroundColor3 = b2, BackgroundTransparency = 1, BorderSizePixel = 0,
                    Visible = false, Parent = b3
                }
            )
            ai(
                'UIGradient',
                {
                    Rotation = b1 and (cc and 270 or 90) or (cc and 180 or 0),
                    Transparency = NumberSequence.new(
                        {
                            NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.4, 0.2),
                            NumberSequenceKeypoint.new(1, 1)
                        }
                    ), Parent = cd
                }
            )
            local ce = b1 and UDim2.new(0.5, 0, cc and 1 or 0, cc and -5 or 5) or UDim2.new(
                cc and 1 or 0, cc and -2 or 2, 0.5, 0
            )
            local cf = ai(
                'TextButton',
                {
                    AnchorPoint = b1 and Vector2.new(0.5, cc and 1 or 0) or Vector2.new(
                        cc and 1 or 0, 0.5
                    ), Position = ce, Size = UDim2.fromOffset(0, 20),
                    AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = z.Surface3,
                    BackgroundTransparency = 1, BorderSizePixel = 0, Text = '',
                    AutoButtonColor = false, Visible = false, ZIndex = 2, Parent = b3
                }
            )
            aj(cf, UDim.new(1, 0))
            local cg = ak(cf, z.Stroke, 1)
            al(cf, 7, 7)
            ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3), Parent = cf
                }
            )
            local ch = ai(
                'ImageLabel',
                {
                    Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1,
                    ImageColor3 = z.Accent, ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit,
                    LayoutOrder = 1, ZIndex = 2, Parent = cf
                }
            )
            aq(
                ch,
                b1 and (cc and 'chevron-down' or 'chevron-up') or (cc and 'chevron-right' or 'chevron-left')
            )
            local ci = 'ImageTransparency'
            if ch.Image == '' then
                ch:Destroy()
                ch = am(
                    {
                        Size = UDim2.fromOffset(10, 20), Text = '\u{203a}', TextSize = 16,
                        TextColor3 = z.Accent, TextTransparency = 1,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextTruncate = Enum.TextTruncate.None,
                        Rotation = b1 and (cc and 90 or -90) or (cc and 0 or 180), LayoutOrder = 1,
                        ZIndex = 2, Parent = cf
                    }
                )
                ci = 'TextTransparency'
            end
            local cj = am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = '',
                    TextSize = 11, TextColor3 = z.Text, TextTransparency = 1,
                    TextTruncate = Enum.TextTruncate.None, Visible = false, LayoutOrder = 2,
                    ZIndex = 2, Parent = cf
                }
            )
            cf.MouseEnter:Connect(
                function()
                    if not ax() then
                        ah(cg, {Color = z.StrokeHover}, 0.12)
                    end
                end
            )
            cf.MouseLeave:Connect(
                function()
                    ah(cg, {Color = z.Stroke}, 0.2)
                end
            )
            cf.MouseButton1Click:Connect(
                function()
                    b8(cb)
                end
            )
            b9[cb] = {
                Direction = cb, Fade = cd, Chip = cf, Stroke = cg, Arrow = ch, ArrowFade = ci,
                Count = cj, Home = ce, Shown = false, Generation = 0
            }
        end
        local function ca(cb, cc)
            if cb.Shown == cc then
                return
            end
            cb.Shown = cc
            cb.Generation += 1
            local cd = cb.Home + (b1 and UDim2.fromOffset(0, cb.Direction * 6) or UDim2.fromOffset(
                cb.Direction * 6, 0
            ))
            local ce = cc and 0 or 1
            if cc then
                cb.Fade.Visible = true
                cb.Chip.Visible = true
                cb.Chip.Position = cd
                ah(
                    cb.Chip, {Position = cb.Home, BackgroundTransparency = 0.08}, 0.3,
                    Enum.EasingStyle.Quint
                )
            else
                ah(
                    cb.Chip, {Position = cd, BackgroundTransparency = 1}, 0.2,
                    Enum.EasingStyle.Quint
                )
                local cf = cb.Generation
                task.delay(
                    0.21,
                    function()
                        if cb.Generation == cf then
                            cb.Fade.Visible = false
                            cb.Chip.Visible = false
                        end
                    end
                )
            end
            ah(cb.Fade, {BackgroundTransparency = ce}, 0.2)
            ah(cb.Stroke, {Transparency = ce}, 0.2)
            ah(cb.Arrow, {[cb.ArrowFade] = ce}, 0.2)
            ah(cb.Count, {TextTransparency = ce}, 0.2)
        end
        local function cb()
            local cc = b6(b_.AbsoluteWindowSize)
            local cd = (b6(b_.AbsoluteCanvasSize) - cc) / b7()
            local ce = b6(b_.CanvasPosition)
            local cf = b6(b_.AbsolutePosition)
            local cg, ch = 0, 0
            for ci, cj in ipairs(b0:GetChildren()) do
                if cj:IsA('GuiObject') and cj.Visible and b6(cj.AbsoluteSize) > 0 then
                    local ck = b6(cj.AbsolutePosition) + b6(cj.AbsoluteSize) / 2 - cf
                    if ck < 0 then
                        cg += 1
                    elseif ck > cc then
                        ch += 1
                    end
                end
            end
            for ci, cj in pairs(b9) do
                local ck = ci < 0 and cg or ch
                cj.Count.Text = tostring(ck)
                cj.Count.Visible = ck > 0
                ca(cj, cd > 1 and (ci < 0 and ce > 1 or ci > 0 and ce < cd - 1))
            end
        end
        for cc, cd in ipairs({'CanvasPosition', 'AbsoluteCanvasSize', 'AbsoluteWindowSize'}) do
            b_:GetPropertyChangedSignal(cd):Connect(cb)
        end
        task.defer(cb)
    end
    function a2:_scrollTabIntoView(bZ)
        local b_ = self.TabList
        local b0 = self.Scale.Scale
        local b1 = (bZ._button.AbsolutePosition.Y - b_.AbsolutePosition.Y) / b0 + b_.CanvasPosition.Y
        local b2 = b1 + bZ._button.AbsoluteSize.Y / b0
        local b3 = b_.AbsoluteWindowSize.Y / b0
        local b5 = b_.CanvasPosition.Y
        if b1 - 8 < b5 then
            b5 = b1 - 8
        elseif b2 + 8 > b5 + b3 then
            b5 = b2 + 8 - b3
        else
            return
        end
        ah(b_, {CanvasPosition = Vector2.new(0, math.max(0, b5))}, 0.35, Enum.EasingStyle.Quint)
    end
    function a2:_closePopups()
        if self._closePopup then
            self._closePopup()
        end
    end
    function a2:_popoutLayer()
        if self._popLayer then
            return self._popLayer
        end
        local bZ = ai(
            'Frame',
            {
                Name = 'PopOuts', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                ZIndex = 20, Parent = self.Gui
            }
        )
        local b_ = ai('UIScale', {Parent = bZ})
        self._popLayer = bZ
        self._popPanels = {}
        self:_listen(
            'Render',
            function()
                local b0 = math.max(self.Scale.Scale, 0.05)
                if math.abs(b_.Scale - b0) > 1e-4 then
                    b_.Scale = b0
                    bZ.Size = UDim2.fromScale(1 / b0, 1 / b0)
                end
                bZ.Visible = self.Open == true and not self._destroyed
            end
        )
        return bZ
    end
    function a2:_popupHost(bZ)
        local b_ = self._popLayer
        if b_ and bZ and bZ:IsDescendantOf(b_) then
            return b_
        end
        return self.Body
    end
    function a2:_overPopout(bZ)
        local b_ = self._popLayer
        if not b_ or not b_.Visible then
            return false
        end
        for b0, b1 in ipairs(self._popPanels) do
            if b1.Parent and b1.Visible and az(bZ, b1) then
                return true
            end
        end
        return false
    end
    function a2:_fade(bZ, b_)
        local b0, b1 = self._fader, self.Body
        self._fadeGeneration = (self._fadeGeneration or 0) + 1
        local b2 = self._fadeGeneration
        if b1.Parent ~= b0 then
            b0.GroupTransparency = self._bodyAlpha
            b1.Parent = b0
        end
        b0.Visible = true
        self._bodyAlpha = bZ
        ah(b0, {GroupTransparency = bZ}, b_)
        task.delay(
            b_ + 0.03,
            function()
                if self._fadeGeneration == b2 and bZ <= 0 and not self._destroyed then
                    b1.Parent = self.Root
                    b0.Visible = false
                end
            end
        )
    end
    function a2:SelectTab(bZ)
        if self.CurrentTab == bZ then
            return
        end
        local b_ = self.CurrentTab
        self:_resetSearch()
        self:_closePopups()
        self.CurrentTab = bZ
        self:_settleTransition()
        local b0 = (self._transitionGeneration or 0) + 1
        self._transitionGeneration = b0
        if b_ then
            ah(b_._label, {TextColor3 = z.Muted}, 0.3)
            if b_._icon then
                ar(b_._icon, z.Muted, false, 0.3)
            end
            local b1 = self._outLayer
            b_._page.Parent = b1
            self._outPage = b_._page
            b1.GroupTransparency = 0
            b1.Position = UDim2.fromOffset(0, 0)
            b1.Visible = true
            ah(
                b1, {GroupTransparency = 1, Position = UDim2.fromOffset(0, -6)}, 0.2,
                Enum.EasingStyle.Quint
            )
            task.delay(
                0.18,
                function()
                    if self._transitionGeneration == b0 then
                        self:_settleOut()
                    end
                end
            )
        end
        ah(bZ._button, {BackgroundTransparency = 1}, 0.2)
        ah(bZ._stroke, {Transparency = 1}, 0.2)
        ah(bZ._label, {TextColor3 = z.Text}, 0.3)
        if bZ._icon then
            ar(bZ._icon, z.Text, true, 0.3)
        end
        self:_placeIndicator(bZ)
        self:_scrollTabIntoView(bZ)
        local b1 = bZ._page
        b1.Position = UDim2.fromOffset(0, 0)
        b1.Visible = true
        b1.Parent = self._inLayer
        self._inPage = b1
        bz(self._inLayer)
        task.delay(
            0.32,
            function()
                if self._transitionGeneration == b0 then
                    self:_settleIn()
                end
            end
        )
    end
    function a2:_settleOut()
        local bZ = self._outPage
        if bZ then
            bZ.Parent = self.Content
            bZ.Visible = false
            self._outPage = nil
        end
        self._outLayer.Visible = false
    end
    function a2:_settleIn()
        local bZ = self._inPage
        if bZ then
            bZ.Parent = self.Content
            bZ.Position = UDim2.fromOffset(0, 0)
            self._inPage = nil
        end
        self._inLayer.Visible = false
    end
    function a2:_settleTransition()
        self:_settleOut()
        self:_settleIn()
    end
    local bZ = {
        Rain = {Image = 'rbxassetid://241868005', Count = 90, Stretch = true},
        Snow = {Image = 'rbxassetid://99851851', Count = 60},
        Ember = {Image = 'rbxassetid://242205518', Count = 55},
        Sakura = {Petal = true, Count = 46, Glow = Color3.fromRGB(255, 150, 190), GlowAmount = 0.1},
        Fireflies = {
            Image = A.Glow, Count = 34, Glow = Color3.fromRGB(70, 150, 60), GlowAmount = 0.16
        },
        Matrix = {
            Text = true, Count = 38, Glow = Color3.fromRGB(30, 200, 90), GlowAmount = 0.07,
            Glyphs = '01234567890123456789\u{30a2}\u{30a4}\u{30a6}\u{30a8}\u{30aa}\u{30ab}\u{30ad}\u{30af}\u{30b1}\u{30b3}\u{30b5}\u{30b7}\u{30b9}\u{30bb}\u{30bd}\u{30bf}\u{30c1}\u{30c4}\u{30c6}\u{30c8}\u{30ca}\u{30cb}\u{30cc}\u{30cd}\u{30ce}\u{30cf}\u{30d2}\u{30d5}\u{30d8}\u{30db}\u{30de}\u{30df}\u{30e0}\u{30e1}\u{30e2}\u{30e4}\u{30e6}\u{30e8}\u{30e9}\u{30ea}\u{30eb}\u{30ec}\u{30ed}\u{30ef}\u{30f3}+-*=<>:'
        }
    }
    local b_ = {
        rain = 'Rain', snow = 'Snow', ember = 'Ember', embers = 'Ember', fire = 'Ember',
        hellfire = 'Ember', sakura = 'Sakura', petals = 'Sakura', cherryblossom = 'Sakura',
        firefly = 'Fireflies', fireflies = 'Fireflies', matrix = 'Matrix', matrixrain = 'Matrix',
        code = 'Matrix'
    }
    local b0 = Vector2.new(7 / 420, 151 / 263)
    local b1 = Random.new()
    local function b2(b3)
        if type(b3) == 'string' and ({ui = true, window = true, inside = true})[b3:lower()] then
            return 'UI'
        end
        return 'Screen'
    end
    local function b3(b5)
        if type(b5) ~= 'string' then
            return 'None'
        end
        return b_[(b5:lower():gsub('[%s_%-]', ''))] or 'None'
    end
    local function b5(b6, b7)
        return b1:NextNumber(b6, b7)
    end
    local function b6(b7, b8, b9, ca, cb)
        b8.Time = b5(0, 10)
        b8.Phase = b5(0, math.pi * 2)
        if b7 == 'Rain' then
            local cc = b5(2, 3.5)
            b8.Size = Vector2.new(cc, b5(26, 52))
            b8.VY = b5(950, 1400)
            b8.VX = b8.VY * 0.12
            b8.Sway, b8.Spin = 0, 0
            b8.Rotation = -math.deg(math.atan2(b8.VX, b8.VY))
            b8.Alpha = b5(0, 0.35)
            b8.X = b5(-0.15 * b9, b9)
            b8.Y = cb and b5(-40, ca) or b5(-120, -b8.Size.Y)
        elseif b7 == 'Snow' then
            local cc = b5(6, 17)
            b8.Size = Vector2.new(cc, cc)
            b8.VY = b5(30, 55) * (0.6 + cc / 17)
            b8.VX = b5(-8, 14)
            b8.Sway = b5(12, 38)
            b8.Frequency = b5(0.5, 1.3)
            b8.Spin = b5(-60, 60)
            b8.Rotation = b5(0, 360)
            b8.Alpha = b5(0.05, 0.45)
            b8.X = b5(0, b9)
            b8.Y = cb and b5(-20, ca) or b5(-60, -cc)
        elseif b7 == 'Sakura' then
            local cc = b5(7, 14)
            b8.Size = Vector2.new(cc, cc * b5(0.55, 0.75))
            b8.VY = b5(35, 70)
            b8.VX = b5(18, 45)
            b8.Sway = b5(14, 34)
            b8.Frequency = b5(0.6, 1.4)
            b8.Flutter = b5(1.2, 2.6)
            b8.Spin = b5(-90, 90)
            b8.Rotation = b5(0, 360)
            b8.Alpha = b5(0.05, 0.35)
            b8.Color = Color3.fromRGB(255, 205, 220):Lerp(Color3.fromRGB(255, 140, 180), b5(0, 1))
            b8.X = b5(-0.25 * b9, b9)
            b8.Y = cb and b5(-20, ca) or b5(-60, -cc)
        elseif b7 == 'Fireflies' then
            local cc = b5(14, 28)
            b8.Size = Vector2.new(cc, cc)
            b8.VY = b5(-14, 8)
            b8.VX = b5(-12, 12)
            b8.Sway = b5(10, 30)
            b8.SwayY = b5(8, 22)
            b8.Frequency = b5(0.3, 0.8)
            b8.Spin, b8.Rotation = 0, 0
            b8.Alpha = b5(0, 0.25)
            b8.Life = b5(5, 11)
            b8.Age = cb and b5(0, b8.Life) or 0
            b8.Pulse = b5(1.5, 3.5)
            b8.Color = Color3.fromRGB(200, 255, 120):Lerp(Color3.fromRGB(255, 230, 120), b5(0, 1))
            b8.X = b5(0, b9)
            b8.Y = b5(ca * 0.15, ca)
        elseif b7 == 'Matrix' then
            local cc = bZ.Matrix
            if not cc.List then
                cc.List = {}
                for cd, ce in utf8.codes(cc.Glyphs) do
                    table.insert(cc.List, utf8.char(ce))
                end
            end
            local cd = cc.List
            local ce = math.floor(b5(12, 19))
            local cf = math.floor(b5(8, 20))
            b8.TextSize = ce
            b8.Size = Vector2.new(ce + 6, ce * cf)
            b8.VY = b5(160, 360) * (ce / 15)
            b8.VX, b8.Sway, b8.Spin, b8.Rotation = 0, 0, 0, 0
            b8.Alpha = b5(0, 0.25) + (19 - ce) * 0.04
            b8.X = math.floor(b5(0, b9) / 18) * 18 + 9
            b8.Y = cb and b5(-b8.Size.Y / 2, ca) or -b8.Size.Y / 2 - b5(0, 240)
            b8.Chars = {}
            for cg = 1, cf do
                b8.Chars[cg] = cd[math.random(#cd)]
            end
            b8.Shuffle = b5(0.05, 0.2)
        else
            local cc = b5(4, 12)
            b8.Size = Vector2.new(cc, cc)
            b8.VY = -b5(60, 170)
            b8.VX = b5(-12, 12)
            b8.Sway = b5(8, 28)
            b8.Frequency = b5(1, 2.4)
            b8.Spin = b5(-140, 140)
            b8.Rotation = b5(0, 360)
            b8.Alpha = b5(0, 0.3)
            b8.Color = Color3.fromRGB(255, 70, 20):Lerp(Color3.fromRGB(255, 190, 70), b5(0, 1))
            b8.X = b5(0, b9)
            b8.Y = cb and b5(ca * 0.2, ca + 10) or ca + b5(10, 80)
        end
        local cc = b8.Label
        if b7 == 'Rain' then
            cc.Size = UDim2.fromOffset(b8.Size.X / b0.X, b8.Size.Y / b0.Y)
        else
            cc.Size = UDim2.fromOffset(b8.Size.X, b8.Size.Y)
        end
        if b7 == 'Matrix' then
            cc.TextSize = b8.TextSize
            cc.Text = table.concat(b8.Chars, '\n')
        elseif b7 == 'Sakura' then
            cc.BackgroundColor3 = b8.Color
        else
            cc.ImageColor3 = b8.Color or (b7 == 'Rain' and Color3.fromRGB(190, 210, 245) or Color3.new(
                1, 1, 1
            ))
        end
    end
    function a2:_buildBackdrop(b7)
        local b8 = ai(
            'Frame',
            {
                Name = 'Backdrop', Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
                Visible = false, ZIndex = 0, Parent = self.Gui
            }
        )
        local b9 = ai(
            'Frame',
            {
                Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 0, Parent = b8
            }
        )
        ai(
            'UIGradient',
            {
                Rotation = 90,
                Transparency = NumberSequence.new(
                    {
                        NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.3),
                        NumberSequenceKeypoint.new(1, 0)
                    }
                ), Parent = b9
            }
        )
        local ca = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1),
                Size = UDim2.fromScale(1, 0.5), BackgroundColor3 = Color3.fromRGB(255, 60, 15),
                BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1, Parent = b8
            }
        )
        ai('UIGradient', {Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = ca})
        local cb = ai(
            'Frame',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true,
                ZIndex = 2, Parent = b8
            }
        )
        ca.Parent = cb
        self._backdrop = b8
        self._backdropTintFrame = b9
        self._backdropHeat = ca
        self._weatherField = cb
        self._weatherParticles = {}
        self._backdropFade = 0
        self._weatherKick = 0
        self._backdropShown = false
        self._backdropEnabled = b7.Enabled ~= false
        self._backdropTint = math.clamp(tonumber(b7.Tint) or 0.45, 0, 1)
        self._backdropDim = b7.Dim ~= false
        self._dimLevel = self._backdropDim and 1 or 0
        self._weatherDensity = math.clamp(tonumber(b7.Density) or 1, 0, 3)
        self._weatherSpeed = math.clamp(tonumber(b7.Speed) or 1, 0.1, 3)
        self.Weather = b3(b7.Weather == nil and 'Snow' or b7.Weather)
        self.WeatherMode = 'Screen'
        self:SetWeatherMode(b7.Mode)
        self:_rebuildWeather()
        table.insert(
            self._frameSteps,
            function(cc)
                self:_stepBackdrop(cc)
            end
        )
    end
    function a2:_weatherSize()
        if self.WeatherMode == 'UI' then
            return Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
        end
        return self.Gui.AbsoluteSize
    end
    function a2:_rebuildWeather()
        for b7, b8 in ipairs(self._weatherParticles) do
            b8.Label:Destroy()
        end
        self._weatherParticles = {}
        local b7 = bZ[self.Weather]
        if not b7 then
            return
        end
        self._backdropHeat.BackgroundColor3 = b7.Glow or Color3.fromRGB(255, 60, 15)
        local b8 = self:_weatherSize()
        local b9 = b7.Count * self._weatherDensity * (self.WeatherMode == 'UI' and 0.45 or 1)
        for ca = 1, math.floor(b9 + 0.5) do
            local cb, cc
            if b7.Text then
                cc = 'TextTransparency'
                cb = ai(
                    'TextLabel',
                    {
                        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Text = '',
                        TextColor3 = Color3.fromRGB(90, 255, 140), TextTransparency = 1,
                        FontFace = Font.fromEnum(Enum.Font.Code),
                        TextXAlignment = Enum.TextXAlignment.Center,
                        TextYAlignment = Enum.TextYAlignment.Top, LineHeight = 1, ZIndex = 2,
                        Parent = self._weatherField
                    }
                )
                ai(
                    'UIGradient',
                    {
                        Rotation = 90,
                        Color = ColorSequence.new(
                            {
                                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                ColorSequenceKeypoint.new(0.88, Color3.new(1, 1, 1)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 255, 240))
                            }
                        ),
                        Transparency = NumberSequence.new(
                            {
                                NumberSequenceKeypoint.new(0, 1),
                                NumberSequenceKeypoint.new(0.6, 0.45),
                                NumberSequenceKeypoint.new(1, 0)
                            }
                        ), Parent = cb
                    }
                )
            elseif b7.Petal then
                cc = 'BackgroundTransparency'
                cb = ai(
                    'Frame',
                    {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 190, 210),
                        BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
                        Parent = self._weatherField
                    }
                )
                aj(cb, UDim.new(1, 0))
                ai(
                    'UIGradient',
                    {
                        Rotation = 35,
                        Color = ColorSequence.new(
                            Color3.new(1, 1, 1), Color3.fromRGB(235, 200, 215)
                        ), Parent = cb
                    }
                )
            else
                cc = 'ImageTransparency'
                cb = ai(
                    'ImageLabel',
                    {
                        AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1,
                        Image = b7.Image, ImageTransparency = 1,
                        ScaleType = b7.Stretch and Enum.ScaleType.Stretch or Enum.ScaleType.Fit,
                        ZIndex = 2, Parent = self._weatherField
                    }
                )
            end
            local cd = {Label = cb, Property = cc}
            b6(self.Weather, cd, b8.X, b8.Y, true)
            table.insert(self._weatherParticles, cd)
        end
    end
    function a2:_stepBackdrop(b7)
        local b8 = self._backdropShown and 1 or 0
        local b9 = self._backdropFade
        if b9 == b8 and b8 == 0 then
            return
        end
        if b9 < b8 then
            b9 = math.min(b9 + b7 / 0.45, b8)
        elseif b9 > b8 then
            b9 = math.max(b9 - b7 / 0.25, b8)
        end
        self._backdropFade = b9
        if b9 <= 0 then
            self._backdrop.Visible = false
            self._weatherField.Visible = false
            return
        end
        local ca = 1 - (1 - b9) ^ 3
        local cb = self.Weather
        local cc = self._dimLevel
        if self._backdropDim then
            cc = math.min(cc + b7 / 0.3, 1)
        else
            cc = math.max(cc - b7 / 0.3, 0)
        end
        self._dimLevel = cc
        self._backdropTintFrame.BackgroundTransparency = 1 - self._backdropTint * ca * cc
        local cd = bZ[cb]
        self._backdropHeat.BackgroundTransparency = cb == 'Ember' and 1 - (0.22 + math.sin(
            os.clock() * 2.1
        ) * 0.05) * ca or cd and cd.GlowAmount and 1 - (cd.GlowAmount + math.sin(os.clock() * 0.8) * cd.GlowAmount * 0.25) * ca or 1
        local ce = self._weatherKick
        self._weatherKick = math.max(ce - b7 * 1.3, 0)
        local cf = self._weatherSpeed * (1 + ce * ce * 2.5)
        local cg = self:_weatherSize()
        local ch, ci = cg.X, cg.Y
        for cj, ck in ipairs(self._weatherParticles) do
            ck.Time += b7
            ck.X += ck.VX * b7 * cf
            ck.Y += ck.VY * b7 * cf
            ck.Rotation += ck.Spin * b7 * cf
            local cl = math.max(ck.Size.X, ck.Size.Y)
            if ck.Life then
                ck.Age += b7
            end
            if (ck.Life and ck.Age > ck.Life) or (not ck.Life and ((ck.VY > 0 and ck.Y > ci + cl) or (ck.VY < 0 and ck.Y < -cl))) then
                b6(cb, ck, ch, ci, false)
            elseif ck.X > ch + cl * 4 then
                ck.X -= ch + cl * 6
            elseif ck.X < -cl * 4 then
                ck.X += ch + cl * 6
            end
            local cm = ck.X
            local cn = 1 - ck.Alpha
            if ck.Sway ~= 0 then
                cm += math.sin(ck.Time * ck.Frequency + ck.Phase) * ck.Sway
            end
            local co = ck.Y
            local cp = ck.Label
            if cb == 'Ember' then
                cn *= math.clamp(ck.Y / (ci * 0.85), 0, 1) ^ 0.6
                cn *= 0.75 + math.sin(ck.Time * 9 + ck.Phase) * 0.25
            elseif cb == 'Sakura' then
                local cq = math.abs(math.cos(ck.Time * ck.Flutter + ck.Phase))
                cp.Size = UDim2.fromOffset(ck.Size.X * (0.3 + cq * 0.7), ck.Size.Y)
            elseif cb == 'Fireflies' then
                co += math.cos(ck.Time * ck.Frequency * 1.3 + ck.Phase) * ck.SwayY
                local cq, cr = ck.Age, ck.Life
                cn *= math.clamp(math.min(cq / 1.2, (cr - cq) / 1.2), 0, 1)
                cn *= 0.5 + math.sin(ck.Time * ck.Pulse + ck.Phase) * 0.5
            elseif cb == 'Matrix' then
                ck.Shuffle -= b7 * cf
                if ck.Shuffle <= 0 then
                    ck.Shuffle = b5(0.05, 0.2)
                    local cq = bZ.Matrix.List
                    local cr = ck.Chars
                    cr[math.random(#cr)] = cq[math.random(#cq)]
                    cr[#cr] = cq[math.random(#cq)]
                    cp.Text = table.concat(cr, '\n')
                end
            end
            cp.Position = UDim2.fromOffset(cm, co)
            cp.Rotation = ck.Rotation
            cp[ck.Property or 'ImageTransparency'] = 1 - cn * ca
        end
    end
    function a2:_refreshBackdrop(b7)
        if not self._backdrop then
            return
        end
        local b8 = self._backdropEnabled and self._introDone and self.Open and not self.Minimized and not self._destroyed
        if b8 and not self._backdropShown then
            self._backdrop.Visible = true
            self._weatherField.Visible = true
            if self._backdropFade <= 0 then
                local b9 = self:_weatherSize()
                for ca, cb in ipairs(self._weatherParticles) do
                    b6(self.Weather, cb, b9.X, b9.Y, true)
                end
            end
            if b7 then
                self._weatherKick = 1
            end
        end
        self._backdropShown = b8 == true
    end
    function a2:SetBackdrop(b7)
        if not self._backdrop then
            return
        end
        self._backdropEnabled = b7 ~= false
        self:_refreshBackdrop(true)
    end
    function a2:SetBackdropTint(b7)
        if not self._backdrop then
            return
        end
        self._backdropTint = math.clamp(tonumber(b7) or 0.45, 0, 1)
    end
    function a2:SetDim(b7)
        if not self._backdrop then
            return
        end
        self._backdropDim = b7 ~= false
    end
    function a2:SetWeatherMode(b7)
        if not self._backdrop then
            return
        end
        b7 = b2(b7)
        local b8 = self._weatherField
        if b7 == 'UI' then
            b8.ZIndex = 0
            b8.Parent = self.Body
        else
            b8.ZIndex = 2
            b8.Parent = self._backdrop
        end
        if b7 == self.WeatherMode then
            return
        end
        self.WeatherMode = b7
        self:_rebuildWeather()
        if self._backdropShown then
            self._weatherKick = 1
        end
    end
    function a2:SetWeather(b7)
        if not self._backdrop then
            return
        end
        local b8 = b3(b7)
        if b8 == self.Weather then
            return
        end
        self.Weather = b8
        self:_rebuildWeather()
        if self._backdropShown then
            self._weatherKick = 1
        end
    end
    function a2:SetWeatherDensity(b7)
        if not self._backdrop then
            return
        end
        self._weatherDensity = math.clamp(tonumber(b7) or 1, 0, 3)
        self:_rebuildWeather()
    end
    function a2:SetWeatherSpeed(b7)
        if not self._backdrop then
            return
        end
        self._weatherSpeed = math.clamp(tonumber(b7) or 1, 0.1, 3)
    end
    local b7 = {
        Top = 8, Width = E and 176 or 168, Height = E and 36 or 32, Wide = 340, Radius = 34,
        Bars = 4, Pinned = 6
    }
    local function b8(b9, ca, cb, cc)
        if b9._ghost then
            b9._ghost:Destroy()
        end
        local cd = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(ca.X, ca.Y), Size = UDim2.fromOffset(cb.X, cb.Y),
                BackgroundColor3 = z.Background, BackgroundTransparency = 1, BorderSizePixel = 0,
                ZIndex = 29, Parent = b9.Gui
            }
        )
        local ce = k._fixedCorner(cd, UDim.new(0, cc))
        local cf = ak(cd, z.Stroke, 1)
        b9._ghost = cd
        return cd, cf, ce
    end
    local function b9(ca, cb, cc, cd, ce, cf)
        ah(
            ca, {Position = UDim2.fromOffset(cc.X, cc.Y), Size = UDim2.fromOffset(cd.X, cd.Y)}, cf,
            Enum.EasingStyle.Quint
        )
        ah(cb, {CornerRadius = UDim.new(0, ce)}, cf, Enum.EasingStyle.Quint)
    end
    local function ca(cb, cc, cd, ce)
        ah(cc, {BackgroundTransparency = 1}, ce, Enum.EasingStyle.Quad)
        ah(cd, {Transparency = 1}, ce, Enum.EasingStyle.Quad)
        task.delay(
            ce + 0.02,
            function()
                if cb._ghost == cc then
                    cb._ghost = nil
                end
                cc:Destroy()
            end
        )
    end
    function a2:_buildMiniBar()
        if self.MiniBar then
            return self.MiniBar
        end
        local cb = self.Gui
        local cc = ai(
            'CanvasGroup',
            {
                Name = 'Island', AnchorPoint = Vector2.new(0.5, 0),
                Position = UDim2.new(0.5, 0, 0, b7.Top),
                Size = UDim2.fromOffset(b7.Width, b7.Height),
                BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, GroupTransparency = 1,
                Visible = false, ZIndex = 30, Parent = cb
            }
        )
        local cd = k._fixedCorner(cc, UDim.new(0, b7.Height / 2))
        local ce = ai('UIScale', {Parent = cc})
        self._miniScale = ce
        local cf = ai('NumberValue', {Value = 1})
        local cg
        self._miniOrb = cc
        local function ch(ci)
            return ai(
                'CanvasGroup',
                {
                    Name = ci, AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.fromScale(0.5, 0), Size = UDim2.new(0, b7.Wide, 0, 400),
                    BackgroundTransparency = 1, GroupTransparency = 1, Parent = cc
                }
            )
        end
        local ci = ai(
            'CanvasGroup',
            {
                Name = 'Compact', Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = Color3.fromRGB(30, 30, 34), BorderSizePixel = 0, Parent = cc
            }
        )
        ai(
            'UIGradient',
            {
                Rotation = 90,
                Color = ColorSequence.new(
                    Color3.fromRGB(255, 255, 255), Color3.fromRGB(120, 120, 120)
                ), Parent = ci
            }
        )
        local cj = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0),
                Size = UDim2.fromOffset(b7.Height - 10, b7.Height - 10),
                BackgroundColor3 = z.Accent, BackgroundTransparency = 0.82, BorderSizePixel = 0,
                Parent = ci
            }
        )
        aj(cj, UDim.new(1, 0))
        local ck = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = z.Accent,
                ScaleType = Enum.ScaleType.Fit, Parent = cj
            }
        )
        aq(ck, self._logoIcon, true)
        local cl = am(
            {
                AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, b7.Height + 2, 0.5, 0),
                Size = UDim2.new(1, -b7.Height - 2 - 72, 0, 18), Text = self.Title, TextSize = 13,
                FontFace = D.Bold, TextColor3 = Color3.fromRGB(244, 244, 246), Parent = ci
            }
        )
        local cm = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1, Parent = ci
            }
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 7), Parent = cm
            }
        )
        local cn = ai(
            'Frame',
            {
                Size = UDim2.fromOffset(b7.Bars * 3 + (b7.Bars - 1) * 2, 16),
                BackgroundTransparency = 1, Visible = false, LayoutOrder = 1, Parent = cm
            }
        )
        local co = {}
        for cp = 1, b7.Bars do
            local cq = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, (cp - 1) * 5, 0.5, 0), Size = UDim2.fromOffset(3, 3),
                    BackgroundColor3 = z.Muted, BorderSizePixel = 0, Parent = cn
                }
            )
            aj(cq, UDim.new(1, 0))
            co[cp] = cq
        end
        local cp = am(
            {
                Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, Text = '',
                TextSize = 13, FontFace = D.Bold, TextTruncate = Enum.TextTruncate.None,
                Visible = false, LayoutOrder = 2, Parent = cm
            }
        )
        local cq = ai(
            'Frame',
            {
                Size = UDim2.fromOffset(6, 6), BackgroundColor3 = z.Accent, BorderSizePixel = 0,
                LayoutOrder = -1, Parent = cm
            }
        )
        aj(cq, UDim.new(1, 0))
        local cr = am(
            {
                Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X, Text = '0s',
                TextSize = 12, FontFace = D.Bold, TextColor3 = Color3.fromRGB(220, 220, 224),
                TextTruncate = Enum.TextTruncate.None, LayoutOrder = 0, Parent = cm
            }
        )
        local cs = ch('Expanded')
        local ct = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(16, 14), Size = UDim2.new(1, -32, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = cs
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = ct}
        )
        local cu = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, LayoutOrder = 1, Parent = ct}
        )
        local cv = ai(
            'ImageLabel',
            {
                Size = UDim2.fromOffset(48, 48), BackgroundColor3 = Color3.fromRGB(38, 38, 41),
                BorderSizePixel = 0,
                Image = 'rbxthumb://type=AvatarHeadShot&id=' .. tostring(j.UserId) .. '&w=150&h=150',
                Parent = cu
            }
        )
        aj(cv, UDim.new(0, 12))
        local cw = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, ImageColor3 = z.Muted,
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit, Parent = cv
            }
        )
        aq(cw, 'user')
        self:_trackAvatar(cv, cw)
        local cx = am(
            {
                Position = UDim2.fromOffset(60, 5), Size = UDim2.new(1, -150, 0, 20), TextSize = 15,
                FontFace = D.Bold, TextColor3 = Color3.fromRGB(244, 244, 246), Parent = cu
            }
        )
        self:_trackName(cx, 'Display')
        local cy = am(
            {
                Position = UDim2.fromOffset(60, 26), Size = UDim2.new(1, -150, 0, 15), Text = '',
                TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted, Parent = cu
            }
        )
        task.spawn(
            function()
                cy.Text = aZ()
            end
        )
        local cz = am(
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 3),
                Size = UDim2.fromOffset(90, 24), Text = '0s', TextSize = 20, FontFace = D.Bold,
                TextColor3 = Color3.fromRGB(244, 244, 246),
                TextXAlignment = Enum.TextXAlignment.Right, Parent = cu
            }
        )
        am(
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 27),
                Size = UDim2.fromOffset(90, 14), Text = 'session', TextSize = 11,
                FontFace = D.Regular, TextColor3 = z.Muted,
                TextXAlignment = Enum.TextXAlignment.Right, Parent = cu
            }
        )
        local cA = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, LayoutOrder = 2, Parent = ct}
        )
        local function cB(cC, cD)
            local cE = ai(
                'Frame',
                {Position = cC, Size = UDim2.new(0.5, -10, 1, 0), BackgroundTransparency = 1, Parent = cA}
            )
            local cF = am(
                {
                    Size = UDim2.new(1, -70, 0, 24), Text = '', TextSize = 20, FontFace = D.Bold,
                    TextColor3 = Color3.fromRGB(244, 244, 246), RichText = true, Parent = cE
                }
            )
            am(
                {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 6),
                    Size = UDim2.fromOffset(70, 14), Text = cD, TextSize = 10, TextColor3 = z.Muted,
                    TextXAlignment = Enum.TextXAlignment.Right, Parent = cE
                }
            )
            local cG = ai(
                'Frame',
                {
                    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -4),
                    Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = Color3.fromRGB(38, 38, 42),
                    BorderSizePixel = 0, Parent = cE
                }
            )
            aj(cG, UDim.new(1, 0))
            local cH = ai(
                'Frame',
                {Size = UDim2.fromScale(0, 1), BackgroundColor3 = z.Success, BorderSizePixel = 0, Parent = cG}
            )
            aj(cH, UDim.new(1, 0))
            return cH, cF
        end
        local cC, cD = cB(UDim2.fromScale(0, 0), 'FRAME RATE')
        local cE, cF = cB(UDim2.new(0.5, 10, 0, 0), 'PING')
        local cG = ai(
            'Frame',
            {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = 3, Parent = ct}
        )
        ai(
            'UIListLayout',
            {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = cG
            }
        )
        local function cH(cI, cJ, cK)
            local cL = ai(
                'Frame',
                {
                    Size = UDim2.fromOffset(0, 30), AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Color3.fromRGB(32, 32, 35), BorderSizePixel = 0,
                    LayoutOrder = cI, Parent = cG
                }
            )
            aj(cL, UDim.new(1, 0))
            al(cL, 14, 14)
            ai(
                'UIListLayout',
                {
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 7), Parent = cL
                }
            )
            am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = cJ,
                    TextSize = 12, FontFace = D.Regular, TextColor3 = z.Muted,
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = 1, Parent = cL
                }
            )
            return am(
                {
                    Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = '',
                    TextSize = 12, FontFace = D.Bold,
                    TextColor3 = cK or Color3.fromRGB(244, 244, 246),
                    TextTruncate = Enum.TextTruncate.None, LayoutOrder = 2, Parent = cL
                }
            )
        end
        local cI = cH(1, 'Players')
        local cJ = cH(2, 'Running', z.Accent)
        local cK = cH(3, 'Tab')
        local cL = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, Visible = false,
                LayoutOrder = 4, Parent = ct
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = cL}
        )
        local cM = am(
            {
                Size = UDim2.new(1, 0, 0, 15), Text = '', TextSize = 12, FontFace = D.Regular,
                TextColor3 = Color3.fromRGB(200, 200, 206), RichText = true, Visible = false,
                LayoutOrder = 4, Parent = ct
            }
        )
        local cN = am(
            {
                Size = UDim2.new(1, 0, 0, 14), TextSize = 11, FontFace = D.Regular,
                TextColor3 = z.Muted, LayoutOrder = 5, Parent = ct
            }
        )
        local cO = self._sessionStart or os.clock()
        local cP, cQ, cR = 0, os.clock(), 60
        self:_listen(
            'Render',
            function()
                cP += 1
                local cS = os.clock()
                if cS - cQ >= 0.5 then
                    cR = math.floor(cP / (cS - cQ) + 0.5)
                    cP, cQ = 0, cS
                end
            end
        )
        local function cS()
            cz.Text = bA(os.clock() - cO)
            cr.Text = cz.Text
            ah(cq, {BackgroundColor3 = k._healthColor(cR, 50, 30)}, 0.4)
            local cT = '<font size="12" color="#8A8A93"> %s</font>'
            cD.Text = cR .. string.format(cT, 'fps')
            ah(
                cC,
                {
                    Size = UDim2.fromScale(math.clamp(cR / 60, 0.05, 1), 1),
                    BackgroundColor3 = k._healthColor(cR, 50, 30)
                }, 0.4, Enum.EasingStyle.Quint
            )
            local cU, cV = pcall(
                function()
                    return math.floor(j:GetNetworkPing() * 1000)
                end
            )
            cV = cU and cV or 0
            cF.Text = cV .. string.format(cT, 'ms')
            ah(
                cE,
                {
                    Size = UDim2.fromScale(math.clamp(1 - (cV - 40) / 360, 0.05, 1), 1),
                    BackgroundColor3 = k._healthColor(cV, 90, 180, true)
                }, 0.4, Enum.EasingStyle.Quint
            )
            cI.Text = #f:GetPlayers() .. '/' .. f.MaxPlayers
            local cW = self.CurrentTab
            cK.Text = cW and cW.Name or '-'
        end
        task.spawn(
            function()
                while cc.Parent do
                    if cc.Visible and self.Minimized then
                        cS()
                    end
                    task.wait(0.5)
                end
            end
        )
        local cT = ch('Activity')
        local cU = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(16, 13), Size = UDim2.new(1, -32, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = cT
            }
        )
        local cV = ai(
            'Frame',
            {
                Size = UDim2.fromOffset(34, 34), BackgroundColor3 = z.Accent,
                BackgroundTransparency = 0.85, BorderSizePixel = 0, Parent = cU
            }
        )
        aj(cV, UDim.new(1, 0))
        local cW = ai(
            'ImageLabel',
            {
                AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(17, 17), BackgroundTransparency = 1, ImageColor3 = z.Accent,
                ScaleType = Enum.ScaleType.Fit, Parent = cV
            }
        )
        local cX = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(46, 0), Size = UDim2.new(1, -46, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = cU
            }
        )
        ai(
            'UIListLayout',
            {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = cX}
        )
        local cY = am(
            {Size = UDim2.new(1, 0, 0, 18), TextSize = 14, FontFace = D.Bold, LayoutOrder = 1, Parent = cX}
        )
        local cZ = am(
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextSize = 12,
                FontFace = D.Regular, TextColor3 = z.Muted, TextWrapped = true,
                TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top,
                MaxVisibleGraphemes = 140, LayoutOrder = 2, Parent = cX
            }
        )
        local c_ = ai(
            'TextButton',
            {
                Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = '',
                AutoButtonColor = false, ZIndex = 10, Parent = cc
            }
        )
        local c0 = {Compact = ci, Expanded = cs, Activity = cT}
        local c1 = 'Compact'
        local c2 = 0
        local c3, c4
        local c5, c6 = false, false
        local c7 = 0
        local c8, c9, da, db = nil, nil, false, false
        local dc = 0
        local dd = false
        local function de(df)
            if df == 'Expanded' then
                return Vector2.new(b7.Wide, math.floor(ct.AbsoluteSize.Y + 28 + 0.5)), b7.Radius
            elseif df == 'Activity' then
                return
                    Vector2.new(b7.Wide, math.floor(math.max(cU.AbsoluteSize.Y, 34) + 26 + 0.5)),
                    b7.Radius
            end
            return Vector2.new(b7.Width, b7.Height), b7.Height / 2
        end
        local df = self:_readConfigSettings().IslandPosition
        if type(df) == 'table' and tonumber(df.X) and tonumber(df.Y) then
            self._islandAnchor = Vector2.new(
                math.clamp(tonumber(df.X), 0, 1), math.clamp(tonumber(df.Y), 0, 1)
            )
        end
        local dg
        local function dh()
            local di = cb.AbsoluteSize
            local dj = self._islandAnchor
            if not dj then
                return Vector2.new(di.X / 2, b7.Top)
            end
            return Vector2.new(dj.X * di.X, dj.Y * di.Y)
        end
        local function di(dj, dk)
            local dl = cb.AbsoluteSize
            local dm = dk or dh()
            local dn = 6
            local dp = math.clamp(
                dm.X, dj.X / 2 + dn, math.max(dl.X - dj.X / 2 - dn, dj.X / 2 + dn)
            )
            local dq = math.clamp(dm.Y, dn, math.max(dl.Y - dj.Y - dn, dn))
            return Vector2.new(dp, dq)
        end
        local function dj(dk, dl, dm)
            local dn = di(dk)
            if dg then
                dg:Cancel()
                dg = nil
            end
            if dl and dl > 0 then
                dg = ah(
                    cc, {Position = UDim2.fromOffset(dn.X, dn.Y)}, dl, dm or Enum.EasingStyle.Quint
                )
            else
                cc.Position = UDim2.fromOffset(dn.X, dn.Y)
            end
        end
        self._islandReset = function()
            self._islandAnchor = nil
            if cc.Visible then
                dj(Vector2.new(cc.Size.X.Offset, cc.Size.Y.Offset), 0.35)
            end
        end
        local function dk(dl, dm)
            local dn, dp = de(dl)
            local dq = dl ~= c1
            c1 = dl
            c2 += 1
            local dr = c2
            local ds = Vector2.new(cc.Size.X.Offset, cc.Size.Y.Offset)
            local dt = dn.X > ds.X + 1 or dn.Y > ds.Y + 1
            local du = dm and 0 or (dt and 0.5 or 0.38)
            if c3 then
                c3:Cancel()
            end
            if c4 then
                c4:Cancel()
            end
            dj(dn, du)
            c3 = ah(
                cc, {Size = UDim2.fromOffset(dn.X, dn.Y)}, du,
                dt and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
            )
            c4 = ah(cd, {CornerRadius = UDim.new(0, dp)}, du, Enum.EasingStyle.Quint)
            if dq and not dm and not c6 and not da then
                ce.Scale = dt and 0.96 or 1.03
                ah(ce, {Scale = 1}, dt and 0.55 or 0.4, Enum.EasingStyle.Back)
            end
            if dq or dm then
                if cg then
                    cg:Cancel()
                    cg = nil
                end
                if dm then
                    cf.Value = dl == 'Compact' and 1 or 0
                elseif dl == 'Compact' then
                    task.delay(
                        du * 0.55,
                        function()
                            if c2 == dr then
                                cg = ah(cf, {Value = 1}, 0.6, Enum.EasingStyle.Back)
                            end
                        end
                    )
                else
                    cg = ah(cf, {Value = 0}, 0.2, Enum.EasingStyle.Quint)
                end
            end
            if not dq and not dm then
                local dv = c0[dl]
                if dv.GroupTransparency > 0 then
                    ah(dv, {GroupTransparency = 0}, 0.22, Enum.EasingStyle.Quad)
                end
                if dv ~= ci and dv.Position ~= UDim2.fromScale(0.5, 0) then
                    ah(dv, {Position = UDim2.fromScale(0.5, 0)}, 0.32, Enum.EasingStyle.Quint)
                end
                return
            end
            for dv, dw in pairs(c0) do
                if dv ~= dl then
                    ah(dw, {GroupTransparency = 1}, dm and 0 or 0.14, Enum.EasingStyle.Quad)
                end
            end
            local dv = c0[dl]
            if dm then
                dv.GroupTransparency = 0
                if dv ~= ci then
                    dv.Position = UDim2.fromScale(0.5, 0)
                end
            else
                if dv ~= ci then
                    dv.Position = UDim2.new(0.5, 0, 0, 6)
                end
                task.delay(
                    0.1,
                    function()
                        if c2 == dr then
                            ah(dv, {GroupTransparency = 0}, 0.22, Enum.EasingStyle.Quad)
                            if dv ~= ci then
                                ah(
                                    dv, {Position = UDim2.fromScale(0.5, 0)}, 0.32,
                                    Enum.EasingStyle.Quint
                                )
                            end
                        end
                    end
                )
            end
        end
        local function dl()
            if c5 and not E and not da then
                dk('Expanded')
            elseif dd then
                dk('Activity')
            elseif self.IslandStyle == 'Always Show' and not da then
                self:_refreshMini()
                cS()
                dk('Expanded')
            else
                dk('Compact')
            end
        end
        self._islandSettle = function()
            if self.Minimized and cc.Visible and not da then
                dl()
            end
        end
        function self:_miniLand()
            c5, dd = false, false
            dc += 1
            ce.Scale = 1
            dk('Compact', true)
            local dm = Vector2.new(b7.Width, b7.Height)
            local dn = di(dm)
            return Vector2.new(dn.X - dm.X / 2, dn.Y), dm
        end
        c_.MouseEnter:Connect(
            function()
                if ax() or da then
                    return
                end
                c5 = true
                c7 += 1
                local dm = c7
                if c1 == 'Expanded' then
                    return
                end
                if not c6 then
                    ah(ce, {Scale = 1.04}, 0.18, Enum.EasingStyle.Quint)
                end
                task.delay(
                    0.12,
                    function()
                        if c7 == dm and c5 and self.Minimized and not da then
                            self:_refreshMini()
                            cS()
                            dk('Expanded')
                        end
                    end
                )
            end
        )
        c_.MouseLeave:Connect(
            function()
                c5 = false
                c7 += 1
                local dm = c7
                if not c6 then
                    ah(ce, {Scale = 1}, 0.25, Enum.EasingStyle.Quint)
                end
                task.delay(
                    c1 == 'Expanded' and 0.28 or 0.1,
                    function()
                        if c7 == dm and not c5 and self.Minimized then
                            dl()
                        end
                    end
                )
            end
        )
        c_.InputBegan:Connect(
            function(dm)
                if not aw(dm) then
                    return
                end
                c6 = true
                db = false
                ah(ce, {Scale = 0.95}, 0.12, Enum.EasingStyle.Quad)
                if not self._islandLocked then
                    c8 = Vector2.new(dm.Position.X, dm.Position.Y)
                    c9 = di(Vector2.new(b7.Width, b7.Height))
                end
            end
        )
        self:_listen(
            'Changed',
            function(dm)
                if not c8 or not aA(dm) or not self.Minimized then
                    return
                end
                local dn = Vector2.new(dm.Position.X, dm.Position.Y) - c8
                if not da then
                    if dn.Magnitude < (E and 10 or 6) then
                        return
                    end
                    da, db = true, true
                    c5 = false
                    dk('Compact')
                    ah(ce, {Scale = 1.06}, 0.2, Enum.EasingStyle.Quint)
                end
                local dp = di(Vector2.new(b7.Width, b7.Height), c9 + dn)
                local dq = cb.AbsoluteSize
                self._islandAnchor = Vector2.new(dp.X / math.max(dq.X, 1), dp.Y / math.max(dq.Y, 1))
                if dg then
                    dg:Cancel()
                    dg = nil
                end
                cc.Position = UDim2.fromOffset(dp.X, dp.Y)
            end
        )
        table.insert(
            self._connections,
            b.InputEnded:Connect(
                function(dm)
                    if not aw(dm) then
                        return
                    end
                    c8 = nil
                    if c6 then
                        c6 = false
                        ah(ce, {Scale = 1}, 0.35, Enum.EasingStyle.Back)
                    end
                    if da then
                        da = false
                        local dn = Vector2.new(cb.AbsoluteSize.X / 2, b7.Top)
                        local dp = di(Vector2.new(b7.Width, b7.Height))
                        if (dp - dn).Magnitude < 28 then
                            self._islandAnchor = nil
                            dj(Vector2.new(b7.Width, b7.Height), 0.35, Enum.EasingStyle.Back)
                        end
                        local dq = self._islandAnchor
                        self:_writeConfigSettings(
                            {IslandPosition = dq and {X = dq.X, Y = dq.Y} or false}
                        )
                        c5 = not ax() and az(av(), cc)
                        task.delay(
                            0.1,
                            function()
                                if self.Minimized and not da then
                                    dl()
                                end
                            end
                        )
                    end
                end
            )
        )
        table.insert(
            self._connections,
            cb:GetPropertyChangedSignal('AbsoluteSize'):Connect(
                function()
                    if cc.Visible and not da then
                        dj(Vector2.new(cc.Size.X.Offset, cc.Size.Y.Offset), 0)
                    end
                end
            )
        )
        c_.MouseButton1Click:Connect(
            function()
                if db then
                    db = false
                    return
                end
                if self.Minimized then
                    self:Restore()
                end
            end
        )
        self._miniUnhover = function()
            c5, c6, dd = false, false, false
            c8, da = nil, false
            dc += 1
            ce.Scale = 1
            task.delay(
                0.15,
                function()
                    if not self.Minimized then
                        dk('Compact', true)
                    end
                end
            )
        end
        self._islandActivity = function(dm)
            if not self.Minimized or not cc.Visible then
                return
            end
            local dn = a1[dm.Type] or z.Accent
            cY.Text = tostring(dm.Title or 'Notification')
            cY.TextColor3 = a1[dm.Type] or z.Text
            cZ.Text = tostring(dm.Content or '')
            cZ.Visible = cZ.Text ~= ''
            local dp = dm.Icon
            if dp == nil then
                dp = ({Success = 'circle-check', Warning = 'triangle-alert', Error = 'circle-x'})[dm.Type] or 'bell'
            end
            aq(cW, dp)
            if not cW:GetAttribute('CustomIcon') then
                cW.ImageColor3 = dn
            end
            cV.BackgroundColor3 = dn
            dd = true
            dc += 1
            local dq = dc
            task.defer(
                function()
                    if dc == dq and not c5 and not da then
                        dk('Activity')
                        ce.Scale = 0.96
                        ah(ce, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
                    end
                end
            )
            task.delay(
                math.clamp(tonumber(dm.Duration) or 3, 1.5, 5),
                function()
                    if dc == dq then
                        dd = false
                        if self.Minimized and not c5 then
                            dl()
                        end
                    end
                end
            )
        end
        local dm = 0
        self:_listen(
            'Render',
            function()
                if cc.Visible and dm > 0 and c1 == 'Compact' then
                    local dn = os.clock()
                    for dp, dq in ipairs(co) do
                        local dr = 0.5 + 0.5 * math.sin(dn * (6 + dp * 1.4) + dp * 1.9)
                        dq.Size = UDim2.fromOffset(3, math.floor(4 + dr * 11 + 0.5))
                    end
                end
            end
        )
        local dn = am(
            {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
                Size = UDim2.new(1, -52, 0, 18), TextSize = 13, FontFace = D.Bold,
                TextXAlignment = Enum.TextXAlignment.Right, RichText = true, TextTransparency = 1,
                Parent = ci
            }
        )
        local dp = ai(
            'TextButton',
            {
                Name = 'IslandBubble', AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(0, 0), BackgroundColor3 = Color3.fromRGB(26, 26, 30),
                BorderSizePixel = 0, Text = '', AutoButtonColor = false, Visible = false,
                ZIndex = 30, Parent = cb
            }
        )
        aj(dp, UDim.new(1, 0))
        local dq = ai('NumberValue', {Value = 0})
        local dr = false
        local ds = nil
        local function dt(du)
            if du == dr then
                return
            end
            dr = du
            cn.Parent = du and dp or cm
            cn.AnchorPoint = du and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
            cn.Position = du and UDim2.fromScale(0.5, 0.5) or UDim2.new()
            cm.Visible = not du
            ah(dn, {TextTransparency = du and 0 or 1}, 0.2, Enum.EasingStyle.Quad)
            ah(
                dq, {Value = du and 1 or 0}, du and 0.55 or 0.3,
                du and Enum.EasingStyle.Back or Enum.EasingStyle.Quint
            )
            if du then
                ce.Scale = 0.96
                ah(ce, {Scale = 1}, 0.45, Enum.EasingStyle.Back)
            end
        end
        self:_listen(
            'Render',
            function()
                local du = dq.Value * cf.Value
                local dv = cc.Visible and du > 0.02 and cc.GroupTransparency < 0.5
                dp.Visible = dv
                if not dv then
                    return
                end
                local dw = cb.AbsolutePosition
                local dx, dy = cc.AbsolutePosition - dw, cc.AbsoluteSize
                local dz = math.min(dy.Y, b7.Height)
                local dA = 6
                local dB = dx.X + dy.X + dA + dz <= cb.AbsoluteSize.X
                local dC = dB and dx.X + dy.X or dx.X
                local dD = dB and 1 or -1
                local dE = dC - dD * dz * 0.6
                local dF = dC + dD * (dA + dz / 2)
                local dG = dE + (dF - dE) * du
                local dH = math.clamp(0.35 + 0.65 * du, 0, 1.2)
                local dI = math.sin(math.clamp(du, 0, 1) * math.pi)
                dp.Position = UDim2.fromOffset(dG, dx.Y + dz / 2)
                dp.Size = UDim2.fromOffset(dz * dH * (1 + 0.4 * dI), dz * dH * (1 - 0.18 * dI))
                dp.BackgroundTransparency = cc.GroupTransparency
            end
        )
        dp.MouseButton1Click:Connect(
            function()
                if self.Minimized then
                    self:Restore()
                end
            end
        )
        local du = {}
        function self:_refreshMini()
            local dv = 0
            for dw, dx in pairs(k.Flags) do
                if dx._type == 'Toggle' and dx.Value == true then
                    dv += 1
                end
            end
            if dv ~= dm then
                local dw = dv > dm
                dm = dv
                cp.Text = tostring(dv)
                for dx, dy in ipairs(co) do
                    ah(dy, {BackgroundColor3 = dv > 0 and z.Accent or z.Muted}, 0.25)
                    if dv == 0 then
                        ah(dy, {Size = UDim2.fromOffset(3, 3)}, 0.25)
                    end
                end
                if dw and c1 == 'Compact' and cc.Visible then
                    ce.Scale = 1.06
                    ah(ce, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
                end
            end
            cJ.Text = tostring(dv)
            local dw = {}
            for dx, dy in pairs(k.Flags) do
                if dy._type == 'Toggle' and dy.Value == true and dy._searchName ~= '' then
                    table.insert(dw, dy._searchName)
                end
            end
            table.sort(dw)
            local dx = {}
            for dy = 1, math.min(#dw, 3) do
                dx[dy] = k._rich(dw[dy])
            end
            local dy = #dw - #dx
            cM.Text = '<font color="#8A8A93">Running </font>' .. table.concat(
                dx, '<font color="#8A8A93"> \u{b7} </font>'
            ) .. (dy > 0 and string.format('<font color="#8A8A93">  +%d</font>', dy) or '')
            cM.Visible = #dw > 0
            ds = nil
            for dz, dA in ipairs(self._pinned) do
                if not dA._isShown or dA:_isShown() then
                    ds = dA
                    break
                end
            end
            if ds then
                local dz = tostring(ds:Text() or '')
                if dz:gsub('<[^>]*>', ''):match('%S') then
                    dn.Text = dz
                    local dA = ds._shownColor and ds._shownColor() or z.Text
                    local dB, dC, dD = dA:ToHSV()
                    dn.TextColor3 = dD < 0.35 and z.Text or dA
                else
                    ds = nil
                end
            end
            dt(dm > 0 and ds ~= nil)
            local dz = dm > 0 and not dr
            cq.Visible = not dz
            cr.Visible = not dz
            cp.Visible = dz
            cn.Visible = dm > 0
            cm.Visible = not dr
            cl.Visible = not dr
            local dA = typeof(self.Keybind) == 'EnumItem' and aI(self.Keybind)
            cN.Text = E and 'Tap to open' or (dA and ('Click or press ' .. dA .. ' to open') or 'Click to open')
            local dC = {}
            for dD, dE in ipairs(self._pinned) do
                if (not dE._isShown or dE:_isShown()) and #dC < b7.Pinned then
                    table.insert(dC, dE)
                end
            end
            cL.Visible = false
            for dD = 1, math.max(#dC, #du) do
                local dE = dC[dD]
                local dF = du[dD]
                if dE then
                    if not dF then
                        local dG = ai(
                            'Frame',
                            {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = dD, Parent = cL}
                        )
                        dF = {
                            Frame = dG,
                            Key = am(
                                {
                                    Size = UDim2.new(0.5, -4, 1, 0), TextSize = 12,
                                    FontFace = D.Regular, TextColor3 = z.Muted, RichText = true,
                                    Parent = dG
                                }
                            ),
                            Value = am(
                                {
                                    AnchorPoint = Vector2.new(1, 0),
                                    Position = UDim2.fromScale(1, 0),
                                    Size = UDim2.new(0.5, -4, 1, 0), TextSize = 12,
                                    TextXAlignment = Enum.TextXAlignment.Right, RichText = true,
                                    Parent = dG
                                }
                            )
                        }
                        du[dD] = dF
                    end
                    dF.Frame.Visible = true
                    dF.Key.Text = k._rich(dE.Name)
                    dF.Value.Text = dE:Text()
                    local dG = dE._shownColor and dE._shownColor() or z.Text
                    if dF.Value.TextColor3 ~= dG then
                        ah(dF.Value, {TextColor3 = dG}, 0.2)
                    end
                elseif dF then
                    dF.Frame.Visible = false
                end
            end
            if c1 == 'Expanded' and (c5 or self.IslandStyle == 'Always Show') then
                task.defer(
                    function()
                        if c1 == 'Expanded' and (c5 or self.IslandStyle == 'Always Show') and self.Minimized then
                            local dD = de('Expanded')
                            if math.abs(dD.Y - cc.Size.Y.Offset) > 1 then
                                dk('Expanded')
                            end
                        end
                    end
                )
            end
        end
        self.MiniBar = cc
        self.Island = cc
        return cc
    end
    function a2:Minimize()
        if self.Minimized or not self._introDone or not self.Open or self._destroyed then
            return
        end
        self.Minimized = true
        self._minimizeGeneration = (self._minimizeGeneration or 0) + 1
        local cb = self._minimizeGeneration
        self:_closePopups()
        self:_refreshToggleButton()
        self:_refreshBackdrop()
        local cc = self:_buildMiniBar()
        self:_refreshMini()
        local cd = self.Gui
        local ce = self.Root.AbsolutePosition - cd.AbsolutePosition
        local cf = self.Root.AbsoluteSize
        local cg = 1
        if self._ghost then
            ce = self._ghost.AbsolutePosition - cd.AbsolutePosition
            cf = self._ghost.AbsoluteSize
            cg = self._ghost.BackgroundTransparency
        end
        local ch, ci, cj = b8(self, ce, cf, k._radius(10))
        ch.BackgroundTransparency = cg
        ci.Transparency = cg
        ah(ch, {BackgroundTransparency = 0}, 0.11, Enum.EasingStyle.Quad)
        ah(ci, {Transparency = 0}, 0.11, Enum.EasingStyle.Quad)
        ah(self.Scale, {Scale = (self._fitScale or 1) * 0.985}, 0.11, Enum.EasingStyle.Quad)
        ah(self.Shadow, {ImageTransparency = 1}, 0.2)
        cc.Visible = true
        cc.GroupTransparency = 1
        task.delay(
            0.11,
            function()
                if self._minimizeGeneration ~= cb or self._destroyed then
                    return
                end
                self.Root.Visible = false
                self.Scale.Scale = self._fitScale or 1
                local ck, cl = self:_miniLand(ce + cf / 2)
                b9(ch, cj, ck, cl, math.floor(cl.Y / 2), 0.36)
                task.delay(
                    0.3,
                    function()
                        if self._minimizeGeneration ~= cb or self._destroyed then
                            return
                        end
                        self._miniScale.Scale = 0.9
                        ah(self._miniScale, {Scale = 1}, 0.3, Enum.EasingStyle.Quint)
                        ah(cc, {GroupTransparency = 0}, 0.18, Enum.EasingStyle.Quad)
                        ca(self, ch, ci, 0.2)
                        if self.IslandStyle == 'Always Show' then
                            task.delay(
                                0.22,
                                function()
                                    if self._minimizeGeneration == cb and self._islandSettle then
                                        self._islandSettle()
                                    end
                                end
                            )
                        end
                    end
                )
            end
        )
        task.spawn(
            function()
                while self.Minimized and self._minimizeGeneration == cb and not self._destroyed do
                    self:_refreshMini()
                    task.wait(0.5)
                end
            end
        )
    end
    function a2:Restore()
        if not self.Minimized or self._destroyed then
            return
        end
        self.Minimized = false
        self._minimizeGeneration = (self._minimizeGeneration or 0) + 1
        local cb = self._minimizeGeneration
        self:_refreshToggleButton()
        self:_refreshBackdrop(true)
        local cc = self.Gui
        local cd = self.MiniBar
        local ce = self._fitScale or 1
        local cf = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset) * ce
        local cg = self.Root.AbsolutePosition + self.Root.AbsoluteSize / 2 - cc.AbsolutePosition
        local ch = cg - cf / 2
        local ci, cj = ch, cf
        local ck = 1
        if self._ghost then
            ci = self._ghost.AbsolutePosition - cc.AbsolutePosition
            cj = self._ghost.AbsoluteSize
            ck = self._ghost.BackgroundTransparency
        elseif cd and cd.Visible then
            ci = self._miniOrb.AbsolutePosition - cc.AbsolutePosition
            cj = self._miniOrb.AbsoluteSize
        end
        if cd and cd.Visible then
            if self._miniUnhover then
                self._miniUnhover()
            end
            ah(cd, {GroupTransparency = 1}, 0.12, Enum.EasingStyle.Quad)
            task.delay(
                0.12,
                function()
                    if self._minimizeGeneration == cb then
                        cd.Visible = false
                    end
                end
            )
        end
        local cl, cm, cn = b8(self, ci, cj, math.floor(math.min(cj.X, cj.Y) / 2))
        cl.BackgroundTransparency = ck
        cm.Transparency = ck
        ah(cl, {BackgroundTransparency = 0}, 0.1, Enum.EasingStyle.Quad)
        ah(cm, {Transparency = 0}, 0.1, Enum.EasingStyle.Quad)
        b9(cl, cn, ch, cf, k._radius(10), 0.4)
        ah(self.Shadow, {ImageTransparency = self._shadowRest}, 0.45)
        task.delay(
            0.3,
            function()
                if self._minimizeGeneration ~= cb or self._destroyed then
                    return
                end
                self.Scale.Scale = ce
                self.BodyStroke.Transparency = 0
                self.Root.Visible = true
            end
        )
        task.delay(
            0.4,
            function()
                if self._ghost == cl and self._minimizeGeneration == cb then
                    ca(self, cl, cm, 0.22)
                end
            end
        )
    end
    function a2:SetIslandDraggable(cb)
        self._islandLocked = cb == false
    end
    function a2:ResetIslandPosition()
        self._islandAnchor = nil
        if self._islandReset then
            self._islandReset()
        end
        self:_writeConfigSettings({IslandPosition = false})
    end
    function a2:SetMinimized(cb)
        if cb then
            self:Minimize()
        else
            self:Restore()
        end
    end
    function a2:Toggle(cb)
        if not self._introDone then
            return
        end
        if self.Minimized then
            if cb ~= false then
                self:Restore()
            end
            return
        end
        if cb == nil then
            cb = not self.Open
        end
        if cb == self.Open then
            return
        end
        self.Open = cb
        self:_refreshToggleButton()
        self:_refreshBackdrop(cb)
        self._minimizeGeneration = (self._minimizeGeneration or 0) + 1
        local cc = self._minimizeGeneration
        local cd = self.Gui
        local ce = self._fitScale or 1
        local cf = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset) * ce
        local cg = self.Root.AbsolutePosition + self.Root.AbsoluteSize / 2 - cd.AbsolutePosition
        local ch = cf * 0.94
        local ci, cj, ck
        if self._ghost then
            ci = self._ghost.AbsolutePosition - cd.AbsolutePosition
            cj = self._ghost.AbsoluteSize
            ck = self._ghost.BackgroundTransparency
        end
        if cb then
            local cl, cm, cn = b8(self, ci or cg - ch / 2, cj or ch, k._radius(10))
            cl.BackgroundTransparency = ck or 1
            cm.Transparency = ck or 1
            ah(cl, {BackgroundTransparency = 0}, 0.12, Enum.EasingStyle.Quad)
            ah(cm, {Transparency = 0}, 0.12, Enum.EasingStyle.Quad)
            b9(cl, cn, cg - cf / 2, cf, k._radius(10), 0.3)
            ah(self.Shadow, {ImageTransparency = self._shadowRest}, 0.3)
            task.delay(
                0.2,
                function()
                    if self._minimizeGeneration ~= cc or self._destroyed then
                        return
                    end
                    self.Scale.Scale = ce
                    self.BodyStroke.Transparency = 0
                    self.Root.Visible = true
                end
            )
            task.delay(
                0.3,
                function()
                    if self._ghost == cl and self._minimizeGeneration == cc then
                        ca(self, cl, cm, 0.18)
                    end
                end
            )
        else
            self:_closePopups()
            local cl = ci or self.Root.AbsolutePosition - cd.AbsolutePosition
            local cm = cj or self.Root.AbsoluteSize
            local cn, co, cp = b8(self, cl, cm, k._radius(10))
            cn.BackgroundTransparency = ck or 1
            co.Transparency = ck or 1
            ah(cn, {BackgroundTransparency = 0}, 0.08, Enum.EasingStyle.Quad)
            ah(co, {Transparency = 0}, 0.08, Enum.EasingStyle.Quad)
            ah(self.Shadow, {ImageTransparency = 1}, 0.16)
            task.delay(
                0.08,
                function()
                    if self._minimizeGeneration ~= cc or self._destroyed then
                        return
                    end
                    self.Root.Visible = false
                    b9(cn, cp, cg - ch / 2, ch, k._radius(10), 0.2)
                    ca(self, cn, co, 0.16)
                end
            )
        end
    end
    function a2:SetKeepOnScreen(cb)
        self.KeepOnScreen = cb ~= false
        if self.KeepOnScreen then
            self:_clampToScreen()
        end
    end
    function a2:SetKeybind(cb)
        self.Keybind = cb
        if self._keyChipLabel then
            self._keyChipLabel.Text = aI(cb)
        end
    end
    function a2:Notify(cb)
        cb = l(cb, {Text = 'Content', Message = 'Content', Image = 'Icon'})
        if self.Minimized and self._islandActivity then
            self._islandActivity(cb)
        end
        local cc = cb.Duration or 4
        local cd = a1[cb.Type] or z.Text
        self._notifyOrder = self._notifyOrder + 1
        local ce = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
                LayoutOrder = self._notifyOrder, Parent = self.NotifyHolder
            }
        )
        local cf = ai(
            'Frame',
            {
                Position = UDim2.fromOffset(320, 0), Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = ce
            }
        )
        local cg = ai(
            'ImageLabel',
            {
                Position = UDim2.fromOffset(-20, -20), Size = UDim2.new(1, 40, 1, 40),
                BackgroundTransparency = 1, Image = A.Shadow, ImageColor3 = Color3.new(0, 0, 0),
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0, Parent = cf
            }
        )
        local ch = ai(
            'CanvasGroup',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = z.Background, BorderSizePixel = 0, GroupTransparency = 1,
                Parent = cf
            }
        )
        aj(ch, UDim.new(0, 10))
        local ci = ak(ch, z.Stroke)
        ao(ch)
        an(ch, UDim2.fromOffset(260, 120), UDim2.new(1, -10, 0, -10), 0.86, 90)
        local cj = ai(
            'Frame',
            {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = ch
            }
        )
        al(cj, 16, 16, 14, 24)
        local ck = 0
        if cb.Icon then
            aB(cj, cb.Icon, cd == z.Text and z.Accent or cd, UDim2.new(0, 0, 0, 8))
            ck = 24
        end
        am(
            {
                Position = UDim2.fromOffset(ck, 0), Size = UDim2.new(1, -28 - ck, 0, 16),
                Text = cb.Title or 'Notification', TextSize = 14, TextColor3 = cd, Parent = cj
            }
        )
        local cl = ai(
            'TextButton',
            {
                AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 6, 0, -5),
                Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Text = '\u{d7}',
                TextColor3 = z.Muted, TextSize = 22, FontFace = D.Bold, AutoButtonColor = false,
                Parent = cj
            }
        )
        cl.MouseEnter:Connect(
            function()
                ah(cl, {TextColor3 = z.Text}, 0.15)
            end
        )
        cl.MouseLeave:Connect(
            function()
                ah(cl, {TextColor3 = z.Muted}, 0.2)
            end
        )
        if cb.Content then
            am(
                {
                    Position = UDim2.fromOffset(ck, 21), Size = UDim2.new(1, -ck, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y, Text = cb.Content, TextSize = 13,
                    FontFace = D.Regular, TextColor3 = z.Muted, TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = cj
                }
            )
        end
        local cm = ai(
            'Frame',
            {
                AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -8),
                Size = UDim2.new(1, -32, 0, 3), BackgroundColor3 = z.Surface3, BorderSizePixel = 0,
                Parent = ch
            }
        )
        aj(cm, UDim.new(1, 0))
        local cn = ai(
            'Frame',
            {Size = UDim2.fromScale(1, 1), BackgroundColor3 = z.Accent, BorderSizePixel = 0, Parent = cm}
        )
        aj(cn, UDim.new(1, 0))
        task.defer(
            function()
                if ce.Parent then
                    ah(
                        ce, {Size = UDim2.new(1, 0, 0, ch.AbsoluteSize.Y)}, 0.3,
                        Enum.EasingStyle.Quint
                    )
                end
            end
        )
        ah(cf, {Position = UDim2.fromOffset(0, 0)}, 0.5, Enum.EasingStyle.Back)
        ah(ch, {GroupTransparency = 0}, 0.3)
        ah(cg, {ImageTransparency = 0.6}, 0.4)
        ah(cn, {Size = UDim2.fromScale(0, 1)}, cc, Enum.EasingStyle.Linear)
        local co = false
        local function cp()
            if co then
                return
            end
            co = true
            for cq, cr in ipairs(self._toasts) do
                if cr == cp then
                    table.remove(self._toasts, cq)
                    break
                end
            end
            ah(cf, {Position = UDim2.fromOffset(320, 0)}, 0.3, Enum.EasingStyle.Quint)
            ah(ch, {GroupTransparency = 1}, 0.2)
            ah(ci, {Transparency = 1}, 0.15)
            ah(cg, {ImageTransparency = 1}, 0.2)
            task.delay(
                0.22,
                function()
                    ce.ClipsDescendants = true
                    ah(ce, {Size = UDim2.new(1, 0, 0, -4)}, 0.22, Enum.EasingStyle.Quint)
                    task.delay(
                        0.24,
                        function()
                            ce:Destroy()
                        end
                    )
                end
            )
        end
        task.delay(cc, cp)
        cl.MouseButton1Click:Connect(cp)
        table.insert(self._toasts, cp)
        while #self._toasts > self.MaxNotifications do
            local cq = table.remove(self._toasts, 1)
            cq()
        end
        return {Dismiss = cp}
    end
    function a2:Destroy()
        if self._destroyed then
            return
        end
        self._destroyed = true
        for cb, cc in ipairs(k.Windows) do
            if cc == self then
                table.remove(k.Windows, cb)
                break
            end
        end
        for cb, cc in ipairs(self._connections) do
            pcall(
                function()
                    cc:Disconnect()
                end
            )
        end
        self._connections = {}
        self._inputListeners = {Began = {}, Changed = {}, Ended = {}, Render = {}}
        self._frameSteps = {}
        local cb = self.Gui
        local cc = false
        local function cd()
            if cc then
                return
            end
            cc = true
            if not pcall(cb.Destroy, cb) then
                pcall(
                    function()
                        cb.Enabled = false
                    end
                )
            end
        end
        local ce, cf = pcall(
            function()
                if self._dialog then
                    self._dialog.Close()
                end
                self:_closePopups()
                local ce = self._fitScale or 1
                ah(self.Scale, {Scale = ce * 0.92}, 0.22, Enum.EasingStyle.Quint)
                self:_fade(1, 0.2)
                ah(self.BodyStroke, {Transparency = 1}, 0.12)
                ah(self.Shadow, {ImageTransparency = 1}, 0.2)
                if self.MiniBar and self.MiniBar.Visible then
                    ah(self.MiniBar, {GroupTransparency = 1}, 0.18)
                end
                if self._backdrop then
                    self._weatherField.Visible = false
                    ah(self._backdropTintFrame, {BackgroundTransparency = 1}, 0.2)
                    ah(self._backdropHeat, {BackgroundTransparency = 1}, 0.2)
                end
                for cf, cg in ipairs({self.ToggleButton, self.OpenButton}) do
                    if typeof(cg) == 'Instance' and cg:IsA('GuiObject') then
                        ah(cg, {Size = UDim2.fromOffset(0, 0)}, 0.2, Enum.EasingStyle.Quint)
                    end
                end
            end
        )
        if not ce then
            warn(
                [[[AirFlow] unload animation failed, removing the window directly: ]] .. tostring(
                    cf
                )
            )
            cd()
            return
        end
        task.delay(0.24, cd)
    end
    a2.Unload = a2.Destroy
    function k:Destroy()
        for cb = #k.Windows, 1, -1 do
            local cc = k.Windows[cb]
            if cc then
                cc:Destroy()
            end
        end
    end
    k.Unload = k.Destroy
    local cb = getthreadidentity or getidentity or get_thread_identity or (syn and syn.get_thread_identity)
    local cc = setthreadidentity or setidentity or set_thread_identity or (syn and syn.set_thread_identity)
    local cd = nil
    if cb then
        local ce, cf = pcall(cb)
        if ce and type(cf) == 'number' then
            cd = cf
        end
    end
    local function ce()
        local cf = k.Windows[#k.Windows]
        local cg = cf and cf.Gui
        if typeof(cg) ~= 'Instance' then
            return false
        end
        return not pcall(
            function()
                return cg.Name
            end
        )
    end
    local cf = {}
    d.Heartbeat:Connect(
        function()
            if #cf == 0 then
                return
            end
            local cg = cf
            cf = {}
            for ch, ci in ipairs(cg) do
                ci()
            end
        end
    )
    local function cg(ch, ...)
        local ci = table.pack(...)
        local cj = nil
        table.insert(
            cf,
            function()
                cj = table.pack(pcall(ch, table.unpack(ci, 1, ci.n)))
            end
        )
        while cj == nil do
            task.wait()
        end
        if not cj[1] then
            error(cj[2], 0)
        end
        return table.unpack(cj, 2, cj.n)
    end
    local ch = setmetatable({}, {__mode = 'k'})
    local ci
    local function cj(ck)
        return function(...)
            if ce() then
                if cc then
                    pcall(cc, cd or 8)
                end
                if ce() then
                    return ci(cg(ck, ...))
                end
            end
            return ci(ck(...))
        end
    end
    function ci(...)
        for ck = 1, select('#', ...) do
            local cl = select(ck, ...)
            if type(cl) == 'table' and not ch[cl] then
                local cm = getmetatable(cl)
                if cm ~= a2 and cm ~= aS then
                    ch[cl] = true
                    for cn, co in pairs(cl) do
                        if type(cn) == 'string' and type(co) == 'function' and cn:sub(1, 1) ~= '_' then
                            cl[cn] = cj(co)
                        elseif type(cn) == 'number' and type(co) == 'table' then
                            ci(co)
                        end
                    end
                end
            end
        end
        return ...
    end
    for ck, cl in ipairs({k, a2, aS}) do
        for cm, cn in pairs(cl) do
            if type(cm) == 'string' and type(cn) == 'function' and cm:sub(1, 1) ~= '_' then
                cl[cm] = cj(cn)
            end
        end
    end
    return k
end)()
return a
