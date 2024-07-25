<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <v-data-table
          :headers="headers"
          :items="enrollments"
          item-key="_id"
          class="elevation-1"
        >
          <template v-slot:top>
            <v-toolbar flat>
              <v-toolbar-title>Enrollments</v-toolbar-title>
              <v-divider class="mx-4" inset vertical></v-divider>
              <v-spacer></v-spacer>
              <v-dialog v-model="dialog" max-width="500px">
                <template v-slot:activator="{ on, attrs }">
                  <v-btn color="primary" dark class="mb-2" v-bind="attrs" v-on="on">New Enrollment</v-btn>
                </template>
                <v-card>
                  <v-card-title>
                    <span class="headline">New Enrollment</span>
                  </v-card-title>
                  <v-card-text>
                    <v-form ref="form" v-model="valid">
                      <v-select
                        v-model="student"
                        :items="students"
                        item-text="user.firstName"
                        item-value="_id"
                        label="Student"
                        :rules="[rules.required]"
                        required
                      ></v-select>
                      <v-select
                        v-model="course"
                        :items="courses"
                        item-text="name"
                        item-value="_id"
                        label="Course"
                        :rules="[rules.required]"
                        required
                      ></v-select>
                      <v-text-field
                        v-model="fee"
                        label="Fee"
                        type="number"
                        :rules="[rules.required]"
                        required
                      ></v-text-field>
                      <v-text-field
                        v-model="discount"
                        label="Discount"
                        type="number"
                      ></v-text-field>
                    </v-form>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="closeDialog">Cancel</v-btn>
                    <v-btn color="blue darken-1" text @click="saveEnrollment">Save</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-toolbar>
          </template>
          <!-- <template v-slot:item.student="{ item }">
            <span>{{ item.student.user.firstName }} {{ item.student.user.lastName }}</span>
          </template>
          <template v-slot:item.course="{ item }">
            <span>{{ item.course.name }}</span>
          </template>
          <template v-slot:item.actions="{ item }">
            <v-icon small @click="editEnrollment(item)">
              mdi-pencil
            </v-icon>
            <v-icon small @click="deleteEnrollment(item)">
              mdi-delete
            </v-icon>
          </template> -->
        </v-data-table>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, ref, computed, onMounted } from 'vue';
import { useStore } from 'vuex';

export default defineComponent({
  name: 'EnrollmentList',
  setup() {
    const store = useStore();
    const dialog = ref(false);
    const valid = ref(true);
    const student = ref('');
    const course = ref('');
    const fee = ref(0);
    const discount = ref(0);
    const rules = {
      required: (value: any) => !!value || 'Required.',
    };

    const headers = [
      { text: 'Student', value: 'student' },
      { text: 'Course', value: 'course' },
      { text: 'Fee', value: 'fee' },
      { text: 'Discount', value: 'discount' },
      { text: 'Actions', value: 'actions', sortable: false },
    ];

    const enrollments = computed(() => store.getters.enrollments);
    const students = computed(() => store.getters.students);
    const courses = computed(() => store.getters.courses);

    const closeDialog = () => {
      dialog.value = false;
      student.value = '';
      course.value = '';
      fee.value = 0;
      discount.value = 0;
    };

    const saveEnrollment = () => {
      if (valid.value) {
        store.dispatch('addEnrollment', {
          student: student.value,
          course: course.value,
          fee: fee.value,
          discount: discount.value,
        });
        closeDialog();
      }
    };

    const editEnrollment = (enrollment: any) => {
      console.log('Edit enrollment', enrollment);
      // Implement edit functionality
    };

    const deleteEnrollment = (enrollment: any) => {
      console.log('Delete enrollment', enrollment);
      // Implement delete functionality
    };

    onMounted(() => {
      store.dispatch('fetchStudents');
      store.dispatch('fetchCourses');
      store.dispatch('fetchEnrollments');
    });

    return {
      dialog,
      valid,
      student,
      course,
      fee,
      discount,
      rules,
      headers,
      enrollments,
      students,
      courses,
      closeDialog,
      saveEnrollment,
      editEnrollment,
      deleteEnrollment,
    };
  },
});
</script>

<style scoped>
</style>
