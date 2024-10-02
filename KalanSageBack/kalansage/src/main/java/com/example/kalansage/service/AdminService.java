package com.example.kalansage.service;

import com.example.kalansage.model.Admin;

public interface AdminService {
    public Object creerAdmin(Admin admin);

    public Object modifierAdmin(Admin admin);

    public void supprimerAdmin(Long id);

    public Object getAdmin(Long id);

    public Object listerAdmins();
}
