# Project Screen Flow Diagram

This document contains the detailed screen flow for the CharityDonation project, represented using Mermaid syntax. You can render this diagram using the Mermaid Live Editor or any Markdown viewer that supports Mermaid.

```mermaid
graph TD
    %% Define Styles
    classDef public fill:#f9f,stroke:#333,stroke-width:2px;
    classDef auth fill:#fff4dd,stroke:#d4a017,stroke-width:2px;
    classDef user fill:#e1f5fe,stroke:#01579b,stroke-width:2px;
    classDef admin fill:#ffebee,stroke:#c62828,stroke-width:2px;
    classDef action fill:#c8e6c9,stroke:#2e7d32,stroke-dasharray: 5 5;
    classDef modal fill:#f5f5f5,stroke:#616161,stroke-width:2px,stroke-dasharray: 2 2;

    %% --- 1. PHÂN HỆ PUBLIC (Giao diện chung) ---
    subgraph Module_1 [1. Public Interface]
        Home["🏠 Home Page (/)"]:::public
        CDetail["📄 Campaign Detail (/campaign/{id})"]:::public
        Companions["🤝 Partners (/companions)"]:::public
        
        M_Donate["📦 Modal: Donate"]:::modal
        M_Success["✅ Modal: Success (Code)"]:::modal
    end

    %% --- 2. PHÂN HỆ AUTH (Xác thực) ---
    subgraph Module_2 [2. Authentication]
        Login["🔑 Login (/auth/login)"]:::auth
        Register["📝 Register (/auth/register)"]:::auth
        Forgot["❓ Forgot Password"]:::auth
    end

    %% --- 3. PHÂN HỆ USER (Sau đăng nhập) ---
    subgraph Module_3 [3. User Profile]
        Profile["👤 Profile Page (/user/profile)"]:::user
        M_EditProfile["✏️ Modal: Edit Info"]:::modal
        M_ChangePW["🔒 Modal: Change Password"]:::modal
    end

    %% --- 4. PHÂN HỆ ADMIN (Quản trị) ---
    subgraph Module_4 [4. Admin Dashboard]
        ADashboard["📊 Dashboard (/admin/dashboard)"]:::admin
        
        AUsers["👥 User Management"]:::admin
        ACampaigns["🚩 Campaign Management"]:::admin
        ADonations["💰 Donation Approval"]:::admin
        
        M_Extend["📅 Modal: Extend Campaign"]:::modal
    end

    %% --- LUỒNG CHÍNH (ÉP THEO CHIỀU DỌC) ---
    
    %% Từ Public xuống Auth
    Home --> CDetail
    CDetail --> M_Donate
    M_Donate --> M_Success
    
    Home --- Link1[ ]:::transparent --> Login
    Link1 --- Link2[ ]:::transparent --> Profile
    Link2 --- Link3[ ]:::transparent --> ADashboard

    %% Luồng Login chi tiết
    Login --> Register
    Login --> Forgot
    Login -- "User Login" --> Profile
    Login -- "Admin Login" --> ADashboard

    %% Luồng User Detail
    Profile --> M_EditProfile
    Profile --> M_ChangePW
    
    %% Luồng Admin Detail
    ADashboard --> AUsers
    ADashboard --> ACampaigns
    ADashboard --> ADonations
    
    ACampaigns --> M_Extend
    
    %% Các Action ngầm
    ADonations -- "Confirm" --> Act_C["Update Amount"]:::action
    ADonations -- "Reject" --> Act_R["Send Email"]:::action
    
    M_Donate -- "Guest" --> Act_G["Create Shadow Acc"]:::action

    %% CSS cho link ẩn để ép chiều dọc
    class Link1,Link2,Link3 transparent;
    classDef transparent oposite,stroke-width:0px,fill:none;
```
