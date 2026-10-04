<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;

class UserSeeder extends Seeder
{
     public function run(): void
    {
        // Step 1: Define roles
        $webRoles = ['superadmin', 'admin', 'service_provider', 'user'];
        $apiRoles = ['user', 'service_provider'];

        // Step 2: Create roles for 'web' guard
        foreach ($webRoles as $role) {
            Role::firstOrCreate([
                'name' => $role,
                'guard_name' => 'web'
            ]);
        }

        // Step 3: Create roles for 'api' guard
        foreach ($apiRoles as $role) {
            Role::firstOrCreate([
                'name' => $role,
                'guard_name' => 'api'
            ]);
        }

        // Step 4: Define user data
        $data = [
            [
                'name' => 'Super Admin',
                'username' => 'superadmin',
                'email' => 'superadmin@admin.com',
                'password' => Hash::make('1'),
                'role' => 'superadmin',
                'guard' => 'web',
            ],
            [
                'name' => 'Admin',
                'username' => 'admin',
                'email' => 'admin@admin.com',
                'password' => Hash::make('1'),
                'role' => 'admin',
                'guard' => 'web',
            ],
            [
                'name' => 'Customer',
                'username' => 'customer',
                'email' => 'customer@user.com',
                'password' => Hash::make('1'),
                'role' => 'customer',
                'guard' => 'web',
            ],
            [
                'name' => 'Regular User',
                'username' => 'user',
                'email' => 'user@user.com',
                'password' => Hash::make('1'),
                'role' => 'user',
                'guard' => 'api', // API user
            ],
            [
                'name' => 'Shop Owner',
                'username' => 'shop',
                'email' => 'service_provider@shop.com',
                'password' => Hash::make('1'),
                'role' => 'service_provider',
                'guard' => 'api', // API user
            ],
        ];

        // Step 5: Create users and assign roles
        foreach ($data as $userData) {
            $roleName = $userData['role'];
            $guard = $userData['guard'];

            // Remove role and guard from user creation data
            unset($userData['role'], $userData['guard']);

            // Create or get user
            $user = User::firstOrCreate(['email' => $userData['email']], $userData);

            // Assign role with proper guard
            $role = Role::where('name', $roleName)->where('guard_name', $guard)->first();

            if ($role) {
                $user->assignRole($role);
            }
        }

        // Optional: output message for debugging
        $this->command->info('Users and Roles seeded successfully.');
    }
}
