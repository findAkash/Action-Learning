<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Departments</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('departments')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('department')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Courses</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('courses')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('course')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Batches</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('batches')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('batch')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Students</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('students')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('student')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Teachers</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('teachers')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('teacher')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Modules</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('modules')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('module')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12" sm="4">
        <v-card>
          <v-card-title>Enrollments</v-card-title>
          <v-card-actions>
            <v-btn @click="viewList('enrollments')" color="primary">Manage</v-btn>
            <v-btn @click="showAddModal('enrollment')" color="secondary">Add New</v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="12">
        <component :is="currentListComponent" @item-selected="editItem" />
      </v-col>
    </v-row>

    <add-department-modal :modelValue="modals.department" @update:modelValue="modals.department = $event" />
    <add-course-modal :modelValue="modals.course" @update:modelValue="modals.course = $event" />
    <add-batch-modal :modelValue="modals.batch" @update:modelValue="modals.batch = $event" />
    <add-student-modal :modelValue="modals.student" @update:modelValue="modals.student = $event" />
    <add-teacher-modal :modelValue="modals.teacher" @update:modelValue="modals.teacher = $event" />
    <add-enrollment-modal :modelValue="modals.enrollment" @update:modelValue="modals.enrollment = $event" />
  </v-container>
</template>

<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import { useStore } from 'vuex';
import DepartmentList from '@/components/DepartmentList.vue';
import CourseList from '@/components/CourseList.vue';
import BatchList from '@/components/BatchList.vue';
import StudentList from '@/components/StudentList.vue';
import TeacherList from '@/components/TeacherList.vue';
import ModuleList from '@/components/ModuleList.vue';
import ScheduleList from '@/components/ScheduleList.vue';
import AddDepartmentModal from '@/components/AddDepartmentModal.vue';
import AddCourseModal from '@/components/AddCourseModal.vue';
import AddBatchModal from '@/components/AddBatchModal.vue';
import AddStudentModal from '@/components/AddStudentModal.vue';
import AddTeacherModal from '@/components/AddTeacherModal.vue';
import AddEnrollmentModal from '@/components/AddEnrollmentModal.vue';

type ModalType = 'department' | 'course' | 'batch' | 'student' | 'teacher' | 'module' | 'enrollment';

export default defineComponent({
  name: 'AdminDashboard',
  components: {
    DepartmentList,
    CourseList,
    BatchList,
    StudentList,
    TeacherList,
    ModuleList,
    ScheduleList,
    AddDepartmentModal,
    AddCourseModal,
    AddBatchModal,
    AddStudentModal,
    AddTeacherModal,
    AddEnrollmentModal
  },
  setup() {
    const store = useStore();
    const currentListComponent = ref('');
    const modals = ref<Record<ModalType, boolean>>({
      department: false,
      course: false,
      batch: false,
      student: false,
      teacher: false,
      module: false,
      enrollment: false,
    });

    onMounted(() => {
        store.dispatch('fetchDepartments');
        store.dispatch('fetchCourses');
        store.dispatch('fetchBatches');
        store.dispatch('fetchStudents');
        store.dispatch('fetchTeachers');
        store.dispatch('fetchModules');
        store.dispatch('fetchModules');
      });

    const viewList = (listType: string) => {
      currentListComponent.value = listType.charAt(0).toUpperCase() + listType.slice(1) + 'List';
    };

    const showAddModal = (itemType: ModalType) => {
      modals.value[itemType] = true;
    };

    const editItem = (itemId: string, itemType: string) => {
      console.log(`Edit ${itemType} with ID: ${itemId}`);
      // Add logic to navigate to the item detail page for editing
    };

    return { currentListComponent, modals, viewList, showAddModal, editItem };
  },
});
</script>
